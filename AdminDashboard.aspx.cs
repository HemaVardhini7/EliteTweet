using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace EliteTweet
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string connStr = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect if not logged in as admin
            if (Session["IsAdmin"] == null || Session["IsAdmin"].ToString() != "true")
            {
                Response.Redirect("AdminLogin.aspx");
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadUsers();
                LoadTweets();
                LoadReports();
                LoadVerificationRequests();
            }
        }

        // ── STATS ──────────────────────────────────────────────────────
        private void LoadStats()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                lblTotalUsers.Text = GetScalar(con, "SELECT COUNT(*) FROM Users").ToString();
                lblTotalTweets.Text = GetScalar(con, "SELECT COUNT(*) FROM Tweets").ToString();
                lblVerifiedUsers.Text = GetScalar(con, "SELECT COUNT(*) FROM Users WHERE IsVerified = 1").ToString();
                lblPendingReports.Text = GetScalar(con, "SELECT COUNT(*) FROM Reports WHERE Status = 'Pending'").ToString();
            }
        }

        private object GetScalar(SqlConnection con, string query)
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                object result = cmd.ExecuteScalar();
                return (result == null || result == DBNull.Value) ? 0 : result;
            }
        }

        // ── USERS ──────────────────────────────────────────────────────
        private void LoadUsers()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT UserId, Name, Username, Email, IsVerified FROM Users ORDER BY UserId DESC";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    pnlNoUsers.Visible = true;
                    rptUsers.Visible = false;
                }
                else
                {
                    pnlNoUsers.Visible = false;
                    rptUsers.Visible = true;
                    rptUsers.DataSource = dt;
                    rptUsers.DataBind();
                }
            }
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string email = e.CommandArgument.ToString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;

                if (e.CommandName == "Verify")
                {
                    cmd.CommandText = "UPDATE Users SET IsVerified = 1 WHERE Email = @Email";
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.ExecuteNonQuery();
                }
                else if (e.CommandName == "Unverify")
                {
                    cmd.CommandText = "UPDATE Users SET IsVerified = 0 WHERE Email = @Email";
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.ExecuteNonQuery();
                }
                else if (e.CommandName == "DeleteUser")
                {
                    // Delete related data first to avoid FK violations
                    SqlCommand del = new SqlCommand("", con);

                    del.CommandText = "DELETE FROM Reports WHERE ReporterEmail = @Email OR ReportedEmail = @Email";
                    del.Parameters.AddWithValue("@Email", email);
                    del.ExecuteNonQuery();

                    del.CommandText = "DELETE FROM Likes WHERE Email = @Email";
                    del.Parameters.Clear();
                    del.Parameters.AddWithValue("@Email", email);
                    del.ExecuteNonQuery();

                    del.CommandText = "DELETE FROM Comments WHERE Email = @Email";
                    del.Parameters.Clear();
                    del.Parameters.AddWithValue("@Email", email);
                    del.ExecuteNonQuery();

                    del.CommandText = "DELETE FROM Retweets WHERE Email = @Email";
                    del.Parameters.Clear();
                    del.Parameters.AddWithValue("@Email", email);
                    del.ExecuteNonQuery();

                    del.CommandText = "DELETE FROM Followers WHERE FollowerEmail = @Email OR FollowingEmail = @Email";
                    del.Parameters.Clear();
                    del.Parameters.AddWithValue("@Email", email);
                    del.ExecuteNonQuery();

                    del.CommandText = "DELETE FROM Tweets WHERE Email = @Email";
                    del.Parameters.Clear();
                    del.Parameters.AddWithValue("@Email", email);
                    del.ExecuteNonQuery();

                    del.CommandText = "DELETE FROM Users WHERE Email = @Email";
                    del.Parameters.Clear();
                    del.Parameters.AddWithValue("@Email", email);
                    del.ExecuteNonQuery();
                }
            }

            LoadStats();
            LoadUsers();
        }

        // ── VERIFICATION REQUESTS ──────────────────────────────

        private void LoadVerificationRequests()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT UserId, Name, Username, Email
            FROM Users
            WHERE VerificationRequest = 1
              AND ISNULL(IsVerified, 0) = 0
            ORDER BY UserId DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    pnlNoVerificationRequests.Visible = dt.Rows.Count == 0;
                    rptVerificationRequests.Visible = dt.Rows.Count > 0;

                    rptVerificationRequests.DataSource = dt;
                    rptVerificationRequests.DataBind();
                }
            }
        }

        protected void rptVerificationRequests_ItemCommand(
    object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "Approve" && e.CommandName != "Reject")
                return;

            string email = Convert.ToString(e.CommandArgument);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                string query;

                if (e.CommandName == "Approve")
                {
                    query = @"
                UPDATE Users
                SET IsVerified = 1,
                    VerificationRequest = 0
                WHERE Email = @Email
                  AND VerificationRequest = 1
                  AND ISNULL(IsVerified, 0) = 0";
                }
                else
                {
                    query = @"
                UPDATE Users
                SET VerificationRequest = 0
                WHERE Email = @Email
                  AND VerificationRequest = 1
                  AND ISNULL(IsVerified, 0) = 0";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadStats();
            LoadUsers();
            LoadVerificationRequests();
        }

        // ── TWEETS ─────────────────────────────────────────────────────
        private void LoadTweets()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT t.TweetId, t.TweetText, t.CreatedAt,
                           u.Name, u.Username,
                           (SELECT COUNT(*) FROM Likes l WHERE l.TweetId = t.TweetId) AS LikeCount
                    FROM Tweets t
                    INNER JOIN Users u ON t.Email = u.Email
                    ORDER BY t.CreatedAt DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    pnlNoTweets.Visible = true;
                    rptTweets.Visible = false;
                }
                else
                {
                    pnlNoTweets.Visible = false;
                    rptTweets.Visible = true;
                    rptTweets.DataSource = dt;
                    rptTweets.DataBind();
                }
            }
        }

        protected void rptTweets_ItemCommand(
    object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteTweet")
                return;

            int tweetId = Convert.ToInt32(e.CommandArgument);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        string query = @"
                    DELETE FROM Bookmarks WHERE TweetId = @TweetId;
                    DELETE FROM Reports WHERE ReportedTweetId = @TweetId;
                    DELETE FROM Likes WHERE TweetId = @TweetId;
                    DELETE FROM ContentModeration WHERE TweetId = @TweetId;
                    DELETE FROM Comments WHERE TweetId = @TweetId;
                    DELETE FROM Retweets WHERE TweetId = @TweetId;
                    DELETE FROM Tweets WHERE TweetId = @TweetId;
                ";

                        using (SqlCommand cmd =
                            new SqlCommand(query, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@TweetId", tweetId);
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

            LoadStats();
            LoadTweets();
        }

        // ── REPORTS ────────────────────────────────────────────────────
        private void LoadReports()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT 
                ReportId,
                ReporterEmail,
                ReportedTweetId,
                ReportedEmail,
                Reason,
                CreatedAt,
                Status
            FROM Reports
            ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        pnlNoReports.Visible = dt.Rows.Count == 0;
                        rptReports.Visible = dt.Rows.Count > 0;

                        if (dt.Rows.Count > 0)
                        {
                            rptReports.DataSource = dt;
                            rptReports.DataBind();
                        }
                        else
                        {
                            rptReports.DataSource = null;
                            rptReports.DataBind();
                        }
                    }
                }
            }
        }

        protected void rptReports_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int reportId = Convert.ToInt32(e.CommandArgument);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;

                if (e.CommandName == "Resolve")
                {
                    cmd.CommandText = "UPDATE Reports SET Status = 'Resolved' WHERE ReportId = @ReportId";
                    cmd.Parameters.AddWithValue("@ReportId", reportId);
                    cmd.ExecuteNonQuery();
                }
                else if (e.CommandName == "DeleteReport")
                {
                    cmd.CommandText = "DELETE FROM Reports WHERE ReportId = @ReportId";
                    cmd.Parameters.AddWithValue("@ReportId", reportId);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadStats();
            LoadReports();
        }

        // ── LOGOUT ─────────────────────────────────────────────────────
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session["IsAdmin"] = null;
            Response.Redirect("AdminLogin.aspx");
        }

        // ── HELPER ─────────────────────────────────────────────────────
        protected string GetTimeAgo(DateTime dt)
        {
            TimeSpan diff = DateTime.Now - dt;
            if (diff.TotalMinutes < 1) return "just now";
            if (diff.TotalMinutes < 60) return (int)diff.TotalMinutes + "m";
            if (diff.TotalHours < 24) return (int)diff.TotalHours + "h";
            if (diff.TotalDays < 7) return (int)diff.TotalDays + "d";
            return dt.ToString("MMM d");
        }
    }
}
