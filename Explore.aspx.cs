using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EliteTweet
{
    public partial class Explore : Page
    {
        string strcon = ConfigurationManager
            .ConnectionStrings["TwitterDB"].ConnectionString;

        private string CurrentEmail
        {
            get { return Convert.ToString(Session["Email"]); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Email"] == null && User.Identity.IsAuthenticated)
                Session["Email"] = User.Identity.Name;

            if (Session["Email"] == null)
            {
                Response.Redirect("LoginForm.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSidebarUser();
                LoadUsers("");
            }
                
        }


        protected void rptUsers_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            DataRowView row = (DataRowView)e.Item.DataItem;

            // Set profile picture
            Image imgProfile = (Image)e.Item.FindControl("imgUserProfile");
            Panel pnlDefaultAvatar = (Panel)e.Item.FindControl("pnlDefaultUserAvatar");

            string profilePicture = row["ProfilePicture"] == DBNull.Value
                ? ""
                : Convert.ToString(row["ProfilePicture"]).Trim();

            if (!string.IsNullOrWhiteSpace(profilePicture))
            {
                if (profilePicture.StartsWith("~/"))
                    profilePicture = profilePicture.Substring(2);

                imgProfile.ImageUrl = ResolveUrl("~/" + profilePicture.TrimStart('/'));
                imgProfile.Visible = true;
                pnlDefaultAvatar.Visible = false;
            }
            else
            {
                imgProfile.Visible = false;
                pnlDefaultAvatar.Visible = true;
            }

            // Keep existing Follow button status logic
            LinkButton btn = (LinkButton)e.Item.FindControl("btnFollow");

            string status = row["FollowStatus"].ToString();

            switch (status)
            {
                case "Pending":
                    btn.Text = "Requested";
                    btn.CssClass = "follow-btn pending";
                    break;

                case "Accepted":
                    btn.Text = "Following";
                    btn.CssClass = "follow-btn following";
                    break;

                default:
                    btn.Text = "Follow";
                    btn.CssClass = "follow-btn";
                    break;
            }
        }

        protected void rptUsers_ItemCommand(
    object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "ToggleFollow")
                return;

            int userId = Convert.ToInt32(e.CommandArgument);
            string myEmail = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();

                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        string query = @"
                    DECLARE @TargetEmail VARCHAR(100);

                    SELECT @TargetEmail = Email
                    FROM Users
                    WHERE UserId = @UserId;

                    IF @TargetEmail IS NOT NULL
                       AND @TargetEmail <> @MyEmail
                    BEGIN
                        IF EXISTS (
                            SELECT 1 FROM Followers
                            WHERE FollowerEmail = @MyEmail
                              AND FollowingEmail = @TargetEmail
                        )
                        BEGIN
                            DELETE FROM Followers
                            WHERE FollowerEmail = @MyEmail
                              AND FollowingEmail = @TargetEmail;
                        END
                        ELSE
                        BEGIN
                            INSERT INTO Followers
                                (FollowerEmail, FollowingEmail, Status)
                            VALUES
                                (@MyEmail, @TargetEmail, 'Pending');
                        END
                    END";

                        using (SqlCommand cmd =
                            new SqlCommand(query, con, transaction))
                        {
                            cmd.Parameters.Add("@UserId", SqlDbType.Int)
                                .Value = userId;

                            cmd.Parameters.Add("@MyEmail", SqlDbType.VarChar, 100)
                                .Value = myEmail;

                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }

            LoadUsers(txtSearch.Text.Trim());
        }

        private void LoadSidebarUser()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT Name, Username, ProfilePicture FROM Users WHERE Email = @Email", con))
            {
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = CurrentEmail;
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblSidebarName.Text = Convert.ToString(reader["Name"]);
                        lblSidebarHandle.Text = "@" + Convert.ToString(reader["Username"]);

                        string profilePicture = reader["ProfilePicture"] == DBNull.Value
                            ? ""
                            : Convert.ToString(reader["ProfilePicture"]).Trim();

                        if (!string.IsNullOrWhiteSpace(profilePicture))
                        {
                            if (profilePicture.StartsWith("~/"))
                                profilePicture = profilePicture.Substring(2);

                            imgSidebarProfile.ImageUrl =
                                ResolveUrl("~/" + profilePicture.TrimStart('/'));

                            imgSidebarProfile.Visible = true;
                            pnlSidebarDefaultAvatar.Visible = false;
                        }
                        else
                        {
                            imgSidebarProfile.Visible = false;
                            pnlSidebarDefaultAvatar.Visible = true;
                        }
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text.Trim());
        }

        private void LoadUsers(string search)
        {
            string query = @"
                    SELECT
                        u.UserId,
                        u.Name,
                        u.Username,
                        u.ProfilePicture,
                        ISNULL(f.Status, 'None') AS FollowStatus
                    FROM Users u
                    LEFT JOIN Followers f
                        ON f.FollowingEmail = u.Email
                        AND f.FollowerEmail = @Email
                    WHERE u.Email <> @Email
                        AND (
                            @Search = ''
                            OR u.Name LIKE '%' + @Search + '%'
                            OR u.Username LIKE '%' + @Search + '%'
                            OR CAST(u.UserId AS VARCHAR(20)) = @Search
                        )
                    ORDER BY u.Name";

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100)
                    .Value = Session["Email"].ToString();

                cmd.Parameters.Add("@Search", SqlDbType.NVarChar, 100)
                    .Value = search;

                DataTable dt = new DataTable();

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    da.Fill(dt);

                rptUsers.DataSource = dt;
                rptUsers.DataBind();

                pnlEmpty.Visible = dt.Rows.Count == 0;
            }
        }
    }
}