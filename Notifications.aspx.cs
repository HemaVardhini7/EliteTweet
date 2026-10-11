using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EliteTweet
{
    public partial class Notifications : Page
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
                LoadRequests();
                LoadActivity();
                LoadSidebarUser();
            }
        }

        private void LoadRequests()
        {
            string query = @"
                SELECT f.FollowerId, u.Name, u.Username
                FROM Followers f
                INNER JOIN Users u
                    ON f.FollowerEmail = u.Email
                WHERE f.FollowingEmail = @Email
                  AND f.Status = 'Pending'
                ORDER BY f.FollowerId DESC";

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100)
                    .Value = Session["Email"].ToString();

                DataTable dt = new DataTable();

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    da.Fill(dt);

                rptRequests.DataSource = dt;
                rptRequests.DataBind();

                pnlNoRequests.Visible = dt.Rows.Count == 0;
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

        private void LoadActivity()
        {
            string query = @"
                SELECT
                    'Like' AS Type,
                    u.Name,
                    u.Username,
                    t.TweetText AS Preview,
                    l.LikedAt AS CreatedAt

                FROM Likes l

                INNER JOIN Tweets t
                    ON l.TweetId = t.TweetId

                INNER JOIN Users u
                    ON l.Email = u.Email

                WHERE t.Email = @Email
                  AND l.Email <> @Email

                UNION ALL

                SELECT
                    'Comment' AS Type,
                    u.Name,
                    u.Username,
                    c.CommentText AS Preview,
                    c.CreatedAt

                FROM Comments c

                INNER JOIN Tweets t
                    ON c.TweetId = t.TweetId

                INNER JOIN Users u
                    ON c.Email = u.Email

                WHERE t.Email = @Email
                  AND c.Email <> @Email

                ORDER BY CreatedAt DESC";

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100)
                    .Value = Session["Email"].ToString();

                DataTable dt = new DataTable();

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    da.Fill(dt);

                rptActivity.DataSource = dt;
                rptActivity.DataBind();

                pnlNoActivity.Visible = dt.Rows.Count == 0;
            }
        }

        protected void rptRequests_ItemCommand(
            object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "AcceptRequest" &&
                e.CommandName != "RejectRequest")
                return;

            if (!int.TryParse(e.CommandArgument.ToString(), out int requestId))
                return;

            string query = e.CommandName == "AcceptRequest"
                ? @"UPDATE Followers
                    SET Status = 'Accepted'
                    WHERE FollowerId = @RequestId
                      AND FollowingEmail = @Email
                      AND Status = 'Pending'"
                : @"DELETE FROM Followers
                    WHERE FollowerId = @RequestId
                      AND FollowingEmail = @Email
                      AND Status = 'Pending'";

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@RequestId", SqlDbType.Int)
                    .Value = requestId;

                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100)
                    .Value = Session["Email"].ToString();

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadRequests();
        }

        protected string GetTimeAgo(DateTime date)
        {
            TimeSpan diff = DateTime.Now - date;

            if (diff.TotalMinutes < 1) return "Just now";
            if (diff.TotalMinutes < 60)
                return (int)diff.TotalMinutes + "m ago";
            if (diff.TotalHours < 24)
                return (int)diff.TotalHours + "h ago";
            if (diff.TotalDays < 7)
                return (int)diff.TotalDays + "d ago";

            return date.ToString("dd MMM yyyy");
        }
    }
}