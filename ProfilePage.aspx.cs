using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.IO;
using System.Web;

namespace EliteTweet
{
    public partial class ProfilePage : Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Email"] == null)
            {
                Response.Redirect("LoginForm.aspx");
                return;
            }

            if (ProfileEmail == null)
            {
                Response.Redirect("Explore.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
                LoadPosts();
                LoadLikedTweets();
                LoadReplies();
                LoadMedia();
                LoadVerificationStatus();
            }
        }

        private void LoadProfile()
        {
            string email = ProfileEmail;
            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT Name, Username, ISNULL(IsVerified, 0) AS IsVerified, ProfilePicture, CoverPicture, Bio FROM Users WHERE Email = @Email";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                string name = dr["Name"].ToString();
                string username = "@" + dr["Username"].ToString();
                bool isVerified = (bool)dr["IsVerified"];

                lblSidebarName.Text = name;
                lblSidebarUsername.Text = username;

                string sidebarProfilePath = dr["ProfilePicture"] == DBNull.Value
                    ? ""
                    : dr["ProfilePicture"].ToString().Trim();

                if (!string.IsNullOrWhiteSpace(sidebarProfilePath))
                {
                    if (sidebarProfilePath.StartsWith("~/"))
                        sidebarProfilePath = sidebarProfilePath.Substring(2);

                    imgSidebarProfile.ImageUrl =
                        ResolveUrl("~/" + sidebarProfilePath.TrimStart('/'));

                    imgSidebarProfile.Visible = true;
                    pnlSidebarDefaultAvatar.Visible = false;
                }
                else
                {
                    imgSidebarProfile.Visible = false;
                    pnlSidebarDefaultAvatar.Visible = true;
                }
                lblTopName.Text = name;
                lblName.Text = name;
                lblUsername.Text = username;
                lblJoined.Text = "Joined March 2026";

                if (isVerified)
                    lblTopVerified.Text = " <i class=\"bi bi-patch-check-fill\" style=\"color:#1d9bf0;\"></i>";

                pnlNotVerified.Visible = !isVerified;
                pnlVerified.Visible = isVerified;
                string profilePath = dr["ProfilePicture"].ToString();
                string coverPath = dr["CoverPicture"].ToString();

                imgProfile.Visible = !string.IsNullOrEmpty(profilePath);
                pnlDefaultAvatar.Visible = !imgProfile.Visible;

                if (imgProfile.Visible)
                    imgProfile.ImageUrl = ResolveUrl("~/" + profilePath);

                imgCover.Visible = !string.IsNullOrEmpty(coverPath);

                if (imgCover.Visible)
                    imgCover.ImageUrl = ResolveUrl("~/" + coverPath);

                lblBio.Text = Server.HtmlEncode(dr["Bio"].ToString());
                txtBio.Text = dr["Bio"].ToString();

                pnlEditProfile.Visible = IsMyProfile;
                pnlFollowProfile.Visible = !IsMyProfile;
            }
            con.Close();

            
            SqlConnection con2 = new SqlConnection(strcon);
            SqlCommand cmd2 = new SqlCommand("SELECT COUNT(*) FROM Tweets WHERE Email = @Email", con2);
            cmd2.Parameters.AddWithValue("@Email", email);
            con2.Open();
            int postCount = (int)cmd2.ExecuteScalar();
            con2.Close();
            lblTopPostCount.Text = postCount + " posts";

            SqlConnection con3 = new SqlConnection(strcon);
            SqlCommand cmd3 = new SqlCommand("SELECT COUNT(*) FROM Followers WHERE FollowerEmail = @Email AND Status = 'Accepted'", con3);
            cmd3.Parameters.AddWithValue("@Email", email);
            con3.Open();
            int following = (int)cmd3.ExecuteScalar();
            con3.Close();
            lblFollowingCount.Text = following.ToString();

            SqlConnection con4 = new SqlConnection(strcon);
            SqlCommand cmd4 = new SqlCommand("SELECT COUNT(*) FROM Followers WHERE FollowingEmail = @Email AND Status = 'Accepted'", con4);
            cmd4.Parameters.AddWithValue("@Email", email);
            con4.Open();
            int followers = (int)cmd4.ExecuteScalar();
            con4.Close();
            lblFollowerCount.Text = followers.ToString();
            if (!IsMyProfile)
            {
                using (SqlConnection followCon = new SqlConnection(strcon))
                using (SqlCommand followCmd = new SqlCommand(@"
        SELECT Status FROM Followers
        WHERE FollowerEmail = @Me
          AND FollowingEmail = @Target", followCon))
                {
                    followCmd.Parameters.AddWithValue(
                        "@Me", Session["Email"].ToString());

                    followCmd.Parameters.AddWithValue(
                        "@Target", ProfileEmail);

                    followCon.Open();

                    string status = Convert.ToString(
                        followCmd.ExecuteScalar());

                    btnProfileFollow.Text =
                        status == "Pending" ? "Requested" :
                        status == "Accepted" ? "Following" : "Follow";
                }
            }


        }

        private void LoadMedia()
        {
            string email = ProfileEmail;

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT ImagePath
        FROM Tweets
        WHERE Email = @Email
          AND ImagePath IS NOT NULL
          AND ImagePath <> ''
        ORDER BY CreatedAt DESC", con))
            {
                cmd.Parameters.AddWithValue("@Email", email);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                con.Open();
                da.Fill(dt);
                con.Close();

                rptMedia.DataSource = dt;
                rptMedia.DataBind();

                pnlNoMedia.Visible = (dt.Rows.Count == 0);
            }
        }

        private string SaveProfileImage(System.Web.UI.WebControls.FileUpload upload)
        {
            if (!upload.HasFile)
                return null;

            string extension = Path.GetExtension(upload.FileName).ToLowerInvariant();

            if (extension != ".jpg" && extension != ".jpeg" &&
                extension != ".png" && extension != ".webp")
                throw new InvalidOperationException("Only JPG, PNG and WebP images are allowed.");

            if (upload.PostedFile.ContentLength > 5 * 1024 * 1024)
                throw new InvalidOperationException("Image must be smaller than 5 MB.");

            string folder = Server.MapPath("~/Uploads/Profiles/");
            Directory.CreateDirectory(folder);

            string filename = Guid.NewGuid().ToString("N") + extension;
            string path = Path.Combine(folder, filename);

            // Verify the file is a readable image, not just a renamed file.
            using (var image = System.Drawing.Image.FromStream(upload.PostedFile.InputStream))
            {
                if (image.Width > 8000 || image.Height > 8000)
                    throw new InvalidOperationException("Image dimensions are too large.");
            }

            upload.PostedFile.InputStream.Position = 0;
            upload.SaveAs(path);

            return "Uploads/Profiles/" + filename;
        }

        protected void btnProfileFollow_Click(object sender, EventArgs e)
        {
            if (IsMyProfile || ProfileEmail == null)
                return;

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(@"
        IF EXISTS (
            SELECT 1 FROM Followers
            WHERE FollowerEmail = @Me
              AND FollowingEmail = @Target
        )
            DELETE FROM Followers
            WHERE FollowerEmail = @Me
              AND FollowingEmail = @Target;
        ELSE
            INSERT INTO Followers (FollowerEmail, FollowingEmail, Status)
            VALUES (@Me, @Target, 'Pending');", con))
            {
                cmd.Parameters.AddWithValue("@Me", Session["Email"].ToString());
                cmd.Parameters.AddWithValue("@Target", ProfileEmail);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect(Request.RawUrl);
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (!IsMyProfile)
                return;

            try
            {
                string profilePath = SaveProfileImage(uploadProfile);
                string coverPath = SaveProfileImage(uploadCover);

                using (SqlConnection con = new SqlConnection(strcon))
                using (SqlCommand cmd = new SqlCommand(@"
            UPDATE Users
            SET Bio = @Bio,
                ProfilePicture = COALESCE(@ProfilePicture, ProfilePicture),
                CoverPicture = COALESCE(@CoverPicture, CoverPicture)
            WHERE Email = @Email", con))
                {
                    cmd.Parameters.AddWithValue("@Bio", txtBio.Text.Trim());
                    cmd.Parameters.AddWithValue("@ProfilePicture",
                        (object)profilePath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CoverPicture",
                        (object)coverPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Email", Session["Email"].ToString());

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                Response.Redirect("ProfilePage.aspx");
            }
            catch (Exception ex)
            {
                lblProfileMessage.Text =
                    Server.HtmlEncode(ex.Message);
            }
        }

        private string ProfileEmail
        {
            get
            {
                string username = Request.QueryString["username"];

                if (string.IsNullOrWhiteSpace(username))
                    return Session["Email"].ToString();

                using (SqlConnection con = new SqlConnection(strcon))
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT Email FROM Users WHERE Username = @Username", con))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    con.Open();

                    object result = cmd.ExecuteScalar();

                    return result == null ? null : result.ToString();
                }
            }
        }

        private bool IsMyProfile =>
            string.Equals(ProfileEmail, Session["Email"].ToString(),
                StringComparison.OrdinalIgnoreCase);

        private void LoadPosts()
        {
            string email = ProfileEmail;
            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT t.TweetId, t.TweetText, t.CreatedAt, u.Name, u.Username, u.ProfilePicture, " +
                          "ISNULL(u.IsVerified, 0) AS IsVerified, " +
                           "(SELECT COUNT(*) FROM Likes    l WHERE l.TweetId = t.TweetId) AS LikeCount, " +
                           "(SELECT COUNT(*) FROM Comments c WHERE c.TweetId = t.TweetId) AS CommentCount, " +
                           "(SELECT COUNT(*) FROM Retweets r WHERE r.TweetId = t.TweetId) AS RetweetCount " +
                           "FROM Tweets t " +
                           "INNER JOIN Users u ON t.Email = u.Email " +
                           "WHERE t.Email = @Email " +
                           "ORDER BY t.CreatedAt DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Open();
            da.Fill(dt);
            con.Close();

            rptPosts.DataSource = dt;
            rptPosts.DataBind();

            pnlNoPosts.Visible = (dt.Rows.Count == 0);
        }

        protected void rptPosts_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != System.Web.UI.WebControls.ListItemType.Item &&
                e.Item.ItemType != System.Web.UI.WebControls.ListItemType.AlternatingItem)
                return;

            DataRowView row = (DataRowView)e.Item.DataItem;

            System.Web.UI.WebControls.Image img =
                (System.Web.UI.WebControls.Image)e.Item.FindControl("imgPostProfile");

            System.Web.UI.WebControls.Panel pnl =
                (System.Web.UI.WebControls.Panel)e.Item.FindControl("pnlPostDefaultAvatar");

            string path = row["ProfilePicture"] == DBNull.Value
                ? ""
                : Convert.ToString(row["ProfilePicture"]).Trim();

            if (!string.IsNullOrWhiteSpace(path))
            {
                if (path.StartsWith("~/"))
                    path = path.Substring(2);

                img.ImageUrl = ResolveUrl("~/" + path.TrimStart('/'));
                img.Visible = true;
                pnl.Visible = false;
            }
            else
            {
                img.Visible = false;
                pnl.Visible = true;
            }
        }
        private void LoadLikedTweets()
        {
            string email = ProfileEmail;
            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT t.TweetId, t.TweetText, t.CreatedAt, u.Name, u.Username, u.ProfilePicture, " +
                           "ISNULL(u.IsVerified, 0) AS IsVerified, " +
                           "(SELECT COUNT(*) FROM Likes    l WHERE l.TweetId = t.TweetId) AS LikeCount, " +
                           "(SELECT COUNT(*) FROM Comments c WHERE c.TweetId = t.TweetId) AS CommentCount, " +
                           "(SELECT COUNT(*) FROM Retweets r WHERE r.TweetId = t.TweetId) AS RetweetCount " +
                           "FROM Tweets t " +
                           "INNER JOIN Users u ON t.Email = u.Email " +
                           "INNER JOIN Likes lk ON lk.TweetId = t.TweetId " +
                           "WHERE lk.Email = @Email " +
                           "ORDER BY t.CreatedAt DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Open();
            da.Fill(dt);
            con.Close();

            rptLikes.DataSource = dt;
            rptLikes.DataBind();

            pnlNoLikes.Visible = (dt.Rows.Count == 0);
        }

        protected void rptLikes_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != System.Web.UI.WebControls.ListItemType.Item &&
                e.Item.ItemType != System.Web.UI.WebControls.ListItemType.AlternatingItem)
                return;

            DataRowView row = (DataRowView)e.Item.DataItem;

            System.Web.UI.WebControls.Image img =
                (System.Web.UI.WebControls.Image)e.Item.FindControl("imgLikeProfile");

            System.Web.UI.WebControls.Panel pnl =
                (System.Web.UI.WebControls.Panel)e.Item.FindControl("pnlLikeDefaultAvatar");

            string path = row["ProfilePicture"] == DBNull.Value
                ? ""
                : Convert.ToString(row["ProfilePicture"]).Trim();

            if (!string.IsNullOrWhiteSpace(path))
            {
                if (path.StartsWith("~/"))
                    path = path.Substring(2);

                img.ImageUrl = ResolveUrl("~/" + path.TrimStart('/'));
                img.Visible = true;
                pnl.Visible = false;
            }
            else
            {
                img.Visible = false;
                pnl.Visible = true;
            }
        }


        private void LoadReplies()
        {
            string email = ProfileEmail;
            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT c.CommentText, c.CreatedAt, u.Name, u.Username, u.ProfilePicture, " +
                "ISNULL(u.IsVerified, 0) AS IsVerified, " +
               "tu.Username AS TweetAuthor , t.TweetText " +
               "FROM Comments c " +
               "INNER JOIN Users u  ON c.Email   = u.Email " +
               "INNER JOIN Tweets t ON c.TweetId = t.TweetId " +
               "INNER JOIN Users tu ON t.Email   = tu.Email " +
               "WHERE c.Email = @Email " +
               "ORDER BY c.CreatedAt DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Open();
            da.Fill(dt);
            con.Close();

            rptReplies.DataSource = dt;
            rptReplies.DataBind();

            pnlNoReplies.Visible = (dt.Rows.Count == 0);
        }

        protected void rptReplies_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != System.Web.UI.WebControls.ListItemType.Item &&
                e.Item.ItemType != System.Web.UI.WebControls.ListItemType.AlternatingItem)
                return;

            DataRowView row = (DataRowView)e.Item.DataItem;

            System.Web.UI.WebControls.Image img =
                (System.Web.UI.WebControls.Image)e.Item.FindControl("imgReplyProfile");

            System.Web.UI.WebControls.Panel pnl =
                (System.Web.UI.WebControls.Panel)e.Item.FindControl("pnlReplyDefaultAvatar");

            string path = row["ProfilePicture"] == DBNull.Value
                ? ""
                : Convert.ToString(row["ProfilePicture"]).Trim();

            if (!string.IsNullOrWhiteSpace(path))
            {
                if (path.StartsWith("~/"))
                    path = path.Substring(2);

                img.ImageUrl = ResolveUrl("~/" + path.TrimStart('/'));
                img.Visible = true;
                pnl.Visible = false;
            }
            else
            {
                img.Visible = false;
                pnl.Visible = true;
            }
        }

        private void LoadVerificationStatus()
        {
            string email = Session["Email"]?.ToString();

            if (string.IsNullOrEmpty(email))
                return;

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
            SELECT IsVerified, VerificationRequest
            FROM Users
            WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            bool isVerified = reader["IsVerified"] != DBNull.Value
                                && Convert.ToBoolean(reader["IsVerified"]);

                            bool requestPending = reader["VerificationRequest"] != DBNull.Value
                                && Convert.ToBoolean(reader["VerificationRequest"]);

                            pnlNotVerified.Visible = !isVerified;

                            if (isVerified)
                            {
                                return;
                            }

                            if (requestPending)
                            {
                                btnGetVerified.Text = "Request pending";
                                btnGetVerified.Enabled = false;
                            }
                            else
                            {
                                btnGetVerified.Text = "Get verified";
                                btnGetVerified.Enabled = true;
                            }
                        }
                    }
                }
            }
        }

        protected void btnGetVerified_Click(object sender, EventArgs e)
        {
            string email = Session["Email"]?.ToString();

            if (string.IsNullOrEmpty(email))
            {
                Response.Redirect("LoginForm.aspx");
                return;
            }

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();

                string query = @"
            UPDATE Users
            SET VerificationRequest = 1
            WHERE Email = @Email
              AND ISNULL(IsVerified, 0) = 0
              AND VerificationRequest = 0";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        btnGetVerified.Text = "Request submitted";
                        btnGetVerified.Enabled = false;
                    }
                    else
                    {
                        string checkQuery = @"
                    SELECT IsVerified, VerificationRequest
                    FROM Users
                    WHERE Email = @Email";

                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                        {
                            checkCmd.Parameters.AddWithValue("@Email", email);

                            using (SqlDataReader reader = checkCmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    bool isVerified = reader["IsVerified"] != DBNull.Value
                                        && Convert.ToBoolean(reader["IsVerified"]);

                                    bool requestPending = reader["VerificationRequest"] != DBNull.Value
                                        && Convert.ToBoolean(reader["VerificationRequest"]);

                                    if (isVerified)
                                    {
                                        btnGetVerified.Text = "Already verified";
                                        btnGetVerified.Enabled = false;
                                    }
                                    else if (requestPending)
                                    {
                                        btnGetVerified.Text = "Request pending";
                                        btnGetVerified.Enabled = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
