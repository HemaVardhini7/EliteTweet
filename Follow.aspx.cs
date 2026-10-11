using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace EliteTweet
{
    public partial class FollowPage : Page
    {
        private readonly string strcon = ConfigurationManager
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
                LoadCounts();
                LoadPeople();
            }
        }

        private string CurrentTab
        {
            get
            {
                return string.Equals(Request.QueryString["tab"], "followers",
                    StringComparison.OrdinalIgnoreCase) ? "followers" : "following";
            }
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

                        // Keep the existing Follow page heading and handle.
                        lblPageTitle.Text = Convert.ToString(reader["Name"]);
                        lblCurrentHandle.Text = "@" + Convert.ToString(reader["Username"]);

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

        private void LoadCounts()
        {
            const string query = @"
                SELECT
                    (SELECT COUNT(*) FROM Followers
                     WHERE FollowerEmail = @Email AND Status = 'Accepted') AS FollowingCount,
                    (SELECT COUNT(*) FROM Followers
                     WHERE FollowingEmail = @Email AND Status = 'Accepted') AS FollowersCount;";

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = CurrentEmail;
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblFollowingCount.Text = Convert.ToString(reader["FollowingCount"]);
                        lblFollowersCount.Text = Convert.ToString(reader["FollowersCount"]);
                    }
                }
            }
        }

        private void LoadPeople()
        {
            bool showFollowers = CurrentTab == "followers";

            tabFollowing.Attributes["class"] = showFollowers ? "tab" : "tab active";
            tabFollowers.Attributes["class"] = showFollowers ? "tab active" : "tab";
            lblListHeading.Text = showFollowers ? "Followers" : "Following";

            string query;

            if (showFollowers)
            {
                query = @"
                    SELECT u.Name, u.Username, u.ProfilePicture
                    FROM Followers f
                    INNER JOIN Users u ON u.Email = f.FollowerEmail
                    WHERE f.FollowingEmail = @Email
                      AND f.Status = 'Accepted'
                    ORDER BY u.Name;";
                lblEmptyTitle.Text = "You don't have any followers yet";
                lblEmptyMessage.Text = "When people follow you, they'll appear here.";
            }
            else
            {
                query = @"
                    SELECT u.Name, u.Username, u.ProfilePicture
                    FROM Followers f
                    INNER JOIN Users u ON u.Email = f.FollowingEmail
                    WHERE f.FollowerEmail = @Email
                      AND f.Status = 'Accepted'
                    ORDER BY u.Name;";
                lblEmptyTitle.Text = "You're not following anyone yet";
                lblEmptyMessage.Text = "When you follow people from Explore, they'll appear here.";
            }

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = CurrentEmail;

                DataTable dt = new DataTable();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(dt);

                rptPeople.DataSource = dt;
                rptPeople.DataBind();
                pnlEmpty.Visible = dt.Rows.Count == 0;
                pnlListHeading.Visible = dt.Rows.Count > 0;
            }
        }
    }
}
