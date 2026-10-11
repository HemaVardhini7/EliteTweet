using EliteTweet.AI;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.Security;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EliteTweet
{
    public partial class HomePage : Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;
     

   
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Email"] == null && User.Identity.IsAuthenticated)
            {
                string email = User.Identity.Name;
                Session["Email"] = email;

                using (var con = new SqlConnection(strcon))
                using (var cmd = new SqlCommand("SELECT Username FROM Users WHERE Email=@Email", con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    Session["username"] = result != null ? result.ToString() : null;
                }
            }
            // Redirect to login if not logged in
            if (Session["Email"] == null)
            {
                Response.Redirect("LoginForm.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CurrentFeed = "ForYou";
                LoadUserInfo();
                LoadTweets();
            }
        }

        protected void lnkLogout_ServerClick(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Clear();
            Response.Redirect("LoginForm.aspx");
        }

        private void LoadUserInfo()
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
            SELECT Name, Username, ProfilePicture
            FROM Users
            WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblName.Text = dr["Name"].ToString();
                            lblUsername.Text = "@" + dr["Username"].ToString();

                            string profilePicture = dr["ProfilePicture"] == DBNull.Value
                                ? ""
                                : dr["ProfilePicture"].ToString().Trim();

                            if (profilePicture.StartsWith("~/"))
                            {
                                profilePicture = profilePicture.Substring(2);
                            }

                            if (!string.IsNullOrWhiteSpace(profilePicture))
                            {
                                string imageUrl = ResolveUrl(
                                    "~/" + profilePicture.TrimStart('/'));

                                // Sidebar avatar
                                imgSidebarProfile.ImageUrl = imageUrl;
                                imgSidebarProfile.Visible = true;
                                pnlSidebarDefaultAvatar.Visible = false;

                                // Main feed composer avatar
                                Image1.ImageUrl = imageUrl;
                                Image1.Visible = true;
                                Panel1.Visible = false;

                                // Post modal avatar
                                imgComposerProfile.ImageUrl = imageUrl;
                                imgComposerProfile.Visible = true;
                                pnlComposerDefaultAvatar.Visible = false;
                            }
                            else
                            {
                                // Sidebar default avatar
                                imgSidebarProfile.Visible = false;
                                pnlSidebarDefaultAvatar.Visible = true;

                                // Main feed default avatar
                                Image1.Visible = false;
                                Panel1.Visible = true;

                                // Modal default avatar
                                imgComposerProfile.Visible = false;
                                pnlComposerDefaultAvatar.Visible = true;
                            }
                        }
                    }
                }
            }
        }
        private void LoadTweets()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
                SELECT
                    t.TweetId,
                    t.TweetText,
                    t.ImagePath,
                    t.CreatedAt,
                    u.Name,
                    u.Username,
                    u.ProfilePicture,
                    ISNULL(u.IsVerified, 0) AS IsVerified,

                    (SELECT COUNT(*)
                     FROM Likes l
                     WHERE l.TweetId = t.TweetId) AS LikeCount,

                    (SELECT COUNT(*)
                     FROM Comments c
                     WHERE c.TweetId = t.TweetId) AS CommentCount,

                    (SELECT COUNT(*)
                     FROM Retweets r
                     WHERE r.TweetId = t.TweetId) AS RetweetCount,

                    CASE WHEN EXISTS (
                        SELECT 1
                        FROM Bookmarks b
                        WHERE b.TweetId = t.TweetId
                          AND b.Email = @Email
                    )
                    THEN 1 ELSE 0 END AS IsBookmarked,

                    CASE WHEN EXISTS (
                        SELECT 1
                        FROM Likes l
                        WHERE l.TweetId = t.TweetId
                          AND l.Email = @Email
                    )
                    THEN 1 ELSE 0 END AS IsLiked

                FROM Tweets t

                INNER JOIN Users u
                    ON t.Email = u.Email

                WHERE
                    (
                        @Feed = 'ForYou'
                        OR
                        (
                            @Feed = 'Following'
                            AND EXISTS (
                                SELECT 1
                                FROM Followers f
                                WHERE f.FollowerEmail = @Email
                                  AND f.FollowingEmail = t.Email
                                  AND f.Status = 'Accepted'
                            )
                        )
                    )

                ORDER BY t.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue(
                        "@Email",
                        Session["Email"].ToString()
                    );

                    cmd.Parameters.AddWithValue(
                        "@Feed",
                        CurrentFeed
                    );

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    rptTweets.DataSource = dt;
                    rptTweets.DataBind();

                    pnlEmptyFeed.Visible = dt.Rows.Count == 0;
                }
            }
        }

        protected void rptTweets_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
            {
                return;
            }

            DataRowView row = (DataRowView)e.Item.DataItem;

            System.Web.UI.WebControls.Image img =
                (System.Web.UI.WebControls.Image)e.Item.FindControl("imgTweetProfile");

            System.Web.UI.WebControls.Panel defaultAvatar =
                (System.Web.UI.WebControls.Panel)e.Item.FindControl("pnlDefaultTweetAvatar");

            string profilePicture = row["ProfilePicture"] == DBNull.Value
                ? ""
                : row["ProfilePicture"].ToString().Trim();

            // Support paths stored with ~/ or without it.
            if (profilePicture.StartsWith("~/"))
            {
                profilePicture = profilePicture.Substring(2);
            }

            if (!string.IsNullOrWhiteSpace(profilePicture))
            {
                img.ImageUrl = ResolveUrl("~/" + profilePicture.TrimStart('/'));
                img.Visible = true;
                defaultAvatar.Visible = false;
            }
            else
            {
                img.Visible = false;
                defaultAvatar.Visible = true;
            }
        }

        protected void btnForYou_Click(object sender, EventArgs e)
        {
            CurrentFeed = "ForYou";

            btnForYou.CssClass = "feed-tab active";
            btnFollowing.CssClass = "feed-tab";

            LoadTweets();
        }

        protected void btnFollowing_Click(object sender, EventArgs e)
        {
            CurrentFeed = "Following";

            btnForYou.CssClass = "feed-tab";
            btnFollowing.CssClass = "feed-tab active";

            LoadTweets();
        }

        protected async void btnPost_Click(object sender, EventArgs e)
        {
            string tweetText = txtTweet.Text.Trim();

            if (string.IsNullOrEmpty(tweetText))
                tweetText = txtModalTweet.Text.Trim();

            if (string.IsNullOrEmpty(tweetText))
            {
                ShowMessage("Please write something before posting.", "danger");
                return;
            }

            if (tweetText.Length > 280)
            {
                ShowMessage("Tweet cannot exceed 280 characters.", "danger");
                return;
            }

            string email = Session["Email"].ToString();

            // ==========================================
            // 1. CHECK TWEET WITH GEMINI
            // ==========================================

            ContentSafetyService service =
                new ContentSafetyService();

            ModerationResult result =
                await service.CheckContentAsync(tweetText);

            // Gemini/API failed
            if (!result.Success)
            {
                ShowMessage(
                    "Content safety check failed. Please try again.",
                    "danger"
                );

                return;
            }

            // ==========================================
            // 2. BLOCK UNSAFE TWEET
            // ==========================================

            if (!result.IsSafe)
            {
                SaveModerationRecord(
                    email,
                    "Tweet",
                    tweetText,
                    result.Category,
                    false,
                    result.Reason,
                    null,
                    null
                );

                // Clear both tweet textboxes
                txtTweet.Text = "";
                txtModalTweet.Text = "";

                ShowMessage(
                    "Your post was blocked because it may violate content safety rules.<br/>" +
                    "Reason: " + Server.HtmlEncode(result.Reason),
                    "danger"
                );

                return;
            }

            // ==========================================
            // 3. TWEET IS SAFE
            // ==========================================

            string imagePath = null;

            // Upload image only after content is approved
            if (fileUpload.HasFile)
            {
                try
                {
                    imagePath = ImageUploadHelper.SaveTweetImage(
                        fileUpload.PostedFile,
                        Server.MapPath("~/UploadedImages/Tweets/"),
                        "UploadedImages/Tweets"
                    );
                }
                catch (ImageUploadHelper.ImageValidationException ex)
                {
                    ShowMessage(ex.Message, "danger");
                    return;
                }
            }

            // ==========================================
            // 4. INSERT TWEET + MODERATION RECORD
            // ==========================================

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();

                SqlTransaction transaction = con.BeginTransaction();

                try
                {
                    string tweetQuery = @"
                INSERT INTO Tweets
                    (Email, TweetText, ImagePath, CreatedAt)
                OUTPUT INSERTED.TweetId
                VALUES
                    (@Email, @TweetText, @ImagePath, GETDATE())";

                    using (SqlCommand tweetCmd =
                        new SqlCommand(tweetQuery, con, transaction))
                    {
                        tweetCmd.Parameters.AddWithValue("@Email", email);
                        tweetCmd.Parameters.AddWithValue("@TweetText", tweetText);
                        tweetCmd.Parameters.AddWithValue(
                            "@ImagePath",
                            (object)imagePath ?? DBNull.Value
                        );

                        int tweetId =
                            Convert.ToInt32(tweetCmd.ExecuteScalar());

                        // Save safe moderation record
                        string moderationQuery = @"
                    INSERT INTO ContentModeration
                    (
                        Email,
                        ContentType,
                        ContentText,
                        Category,
                        IsSafe,
                        Reason,
                        TweetId,
                        CommentId,
                        CreatedAt
                    )
                    VALUES
                    (
                        @Email,
                        @ContentType,
                        @ContentText,
                        @Category,
                        @IsSafe,
                        @Reason,
                        @TweetId,
                        NULL,
                        GETDATE()
                    )";

                        using (SqlCommand moderationCmd =
                            new SqlCommand(moderationQuery, con, transaction))
                        {
                            moderationCmd.Parameters.AddWithValue(
                                "@Email", email);

                            moderationCmd.Parameters.AddWithValue(
                                "@ContentType", "Tweet");

                            moderationCmd.Parameters.AddWithValue(
                                "@ContentText", tweetText);

                            moderationCmd.Parameters.AddWithValue(
                                "@Category", result.Category);

                            moderationCmd.Parameters.AddWithValue(
                                "@IsSafe", true);

                            moderationCmd.Parameters.AddWithValue(
                                "@Reason", result.Reason);

                            moderationCmd.Parameters.AddWithValue(
                                "@TweetId", tweetId);

                            moderationCmd.ExecuteNonQuery();
                        }
                    }

                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();

                    ShowMessage(
                        "Unable to post your tweet. " +
                        Server.HtmlEncode(ex.Message),
                        "danger"
                    );

                    return;
                }
            }

            // ==========================================
            // 5. CLEAR FORM + REFRESH TWEETS
            // ==========================================

            txtTweet.Text = "";
            txtModalTweet.Text = "";

            ShowMessage(
                "Your post was sent and passed the content safety check!",
                "success"
            );

            LoadTweets();
        }

        protected string RenderTweetImage(object imagePathObj)
        {
            string imagePath = imagePathObj as string;
            if (string.IsNullOrWhiteSpace(imagePath)) return string.Empty;

            string url = ResolveUrl("~/" + imagePath.TrimStart('/'));
            return "<div class=\"tweet-image-wrap\"><img src=\"" + url + "\" class=\"tweet-image\" alt=\"Tweet image\" loading=\"lazy\" /></div>";
        }


        protected string GetTimeAgo(DateTime createdAt)
        {
            TimeSpan diff = DateTime.Now - createdAt;

            if (diff.TotalMinutes < 1) return "just now";
            if (diff.TotalMinutes < 60) return (int)diff.TotalMinutes + "m";
            if (diff.TotalHours < 24) return (int)diff.TotalHours + "h";
            if (diff.TotalDays < 7) return (int)diff.TotalDays + "d";

            return createdAt.ToString("MMM d");
        }

        private void SaveModerationRecord(
            string email,
            string contentType,
            string contentText,
            string category,
            bool isSafe,
            string reason,
            int? tweetId,
            int? commentId)
            {
                    using (SqlConnection con =
                        new SqlConnection(strcon))
                    {
                        string query = @"
                    INSERT INTO ContentModeration
                    (
                        Email,
                        ContentType,
                        ContentText,
                        Category,
                        IsSafe,
                        Reason,
                        TweetId,
                        CommentId,
                        CreatedAt
                    )
                    VALUES
                    (
                        @Email,
                        @ContentType,
                        @ContentText,
                        @Category,
                        @IsSafe,
                        @Reason,
                        @TweetId,
                        @CommentId,
                        GETDATE()
                    )";

                        using (SqlCommand cmd =
                            new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue(
                                "@Email", email);

                            cmd.Parameters.AddWithValue(
                                "@ContentType", contentType);

                            cmd.Parameters.AddWithValue(
                                "@ContentText", contentText);

                            cmd.Parameters.AddWithValue(
                                "@Category", category);

                            cmd.Parameters.AddWithValue(
                                "@IsSafe", isSafe);

                            cmd.Parameters.AddWithValue(
                                "@Reason", reason);

                            cmd.Parameters.AddWithValue(
                                "@TweetId",
                                (object)tweetId ?? DBNull.Value);

                            cmd.Parameters.AddWithValue(
                                "@CommentId",
                                (object)commentId ?? DBNull.Value);

                            con.Open();

                            cmd.ExecuteNonQuery();
                        }
                    }
            }

        private void ShowMessage(string text, string type)
        {
            lblMessage.Text =
                "<span class=\"alert-message-text\">" +
                text +
                "</span>" +

                "<button type=\"button\" " +
                "class=\"alert-close-btn\" " +
                "onclick=\"closeAlertMessage(event);\">" +
                "&times;" +
                "</button>";

            messageContainer.Attributes["class"] =
                "alert-tweet alert alert-" + type;

            messageContainer.Visible = true;
        }

protected void btnSubmitBookmark_Click(object sender, EventArgs e)
{
    if (Session["Email"] == null)
    {
        Response.Redirect("LoginForm.aspx");
        return;
    }

    string email = Session["Email"].ToString();

    if (!int.TryParse(hdnBookmarkTweetId.Value, out int tweetId))
        return;

    using (SqlConnection con = new SqlConnection(strcon))
    {
        con.Open();

        string query = @"
            IF EXISTS (
                SELECT 1 FROM Bookmarks
                WHERE TweetId = @TweetId AND Email = @Email
            )
            BEGIN
                DELETE FROM Bookmarks
                WHERE TweetId = @TweetId AND Email = @Email
            END
            ELSE
            BEGIN
                INSERT INTO Bookmarks (TweetId, Email)
                SELECT @TweetId, @Email
                WHERE EXISTS (
                    SELECT 1 FROM Tweets
                    WHERE TweetId = @TweetId
                )
            END";

        using (SqlCommand cmd = new SqlCommand(query, con))
        {
            cmd.Parameters.Add("@TweetId", SqlDbType.Int).Value = tweetId;
            cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = email;

            cmd.ExecuteNonQuery();
        }
    }

    LoadTweets();
}

        protected void btnSubmitReport_Click(object sender, EventArgs e)
        {
            string reporterEmail = Session["Email"].ToString();
            int tweetId = Convert.ToInt32(hdnReportTweetId.Value);
            string reason = hdnReportReason.Value;

            SqlConnection con = new SqlConnection(strcon);
            string query = "INSERT INTO Reports (ReporterEmail, ReportedTweetId, Reason) " +
                           "VALUES (@ReporterEmail, @TweetId, @Reason)";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@ReporterEmail", reporterEmail);
            cmd.Parameters.AddWithValue("@TweetId", tweetId);
            cmd.Parameters.AddWithValue("@Reason", reason);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            ShowMessage("Report submitted successfully.", "success");
            LoadTweets();
        }

        protected async void btnSubmitComment_Click(object sender, EventArgs e)
        {
            string email = Session["Email"].ToString();

            int tweetId =
                Convert.ToInt32(hdnCommentTweetId.Value);

            string commentText =
                txtComment.Text.Trim();

            if (string.IsNullOrEmpty(commentText))
            {
                ShowMessage(
                    "Please write a comment.",
                    "danger"
                );

                return;
            }

            // ==========================================
            // 1. CHECK COMMENT WITH GEMINI
            // ==========================================

            ContentSafetyService service =
                new ContentSafetyService();

            ModerationResult result =
                await service.CheckContentAsync(commentText);

            // Gemini/API failed
            if (!result.Success)
            {
                ShowMessage(
                    "Content safety check failed. Please try again.",
                    "danger"
                );

                return;
            }

            // ==========================================
            // 2. BLOCK UNSAFE COMMENT
            // ==========================================

            if (!result.IsSafe)
            {
                SaveModerationRecord(
                    email,
                    "Comment",
                    commentText,
                    result.Category,
                    false,
                    result.Reason,
                    tweetId,
                    null
                );

                ShowMessage(
                    "Your comment was blocked because it may violate content safety rules.<br/>" +
                    "Reason: " + Server.HtmlEncode(result.Reason),
                    "danger"
                );

                return;
            }

            // ==========================================
            // 3. INSERT SAFE COMMENT
            // ==========================================

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();

                SqlTransaction transaction =
                    con.BeginTransaction();

                try
                {
                    string commentQuery = @"
                INSERT INTO Comments
                    (TweetId, Email, CommentText, CreatedAt)
                OUTPUT INSERTED.CommentId
                VALUES
                    (@TweetId, @Email, @CommentText, GETDATE())";

                    int commentId;

                    using (SqlCommand commentCmd =
                        new SqlCommand(commentQuery, con, transaction))
                    {
                        commentCmd.Parameters.AddWithValue(
                            "@TweetId", tweetId);

                        commentCmd.Parameters.AddWithValue(
                            "@Email", email);

                        commentCmd.Parameters.AddWithValue(
                            "@CommentText", commentText);

                        commentId =
                            Convert.ToInt32(commentCmd.ExecuteScalar());
                    }

                    // ==========================================
                    // 4. SAVE MODERATION RECORD
                    // ==========================================

                    string moderationQuery = @"
                INSERT INTO ContentModeration
                (
                    Email,
                    ContentType,
                    ContentText,
                    Category,
                    IsSafe,
                    Reason,
                    TweetId,
                    CommentId,
                    CreatedAt
                )
                VALUES
                (
                    @Email,
                    @ContentType,
                    @ContentText,
                    @Category,
                    @IsSafe,
                    @Reason,
                    @TweetId,
                    @CommentId,
                    GETDATE()
                )";

                    using (SqlCommand moderationCmd =
                        new SqlCommand(moderationQuery, con, transaction))
                    {
                        moderationCmd.Parameters.AddWithValue(
                            "@Email", email);

                        moderationCmd.Parameters.AddWithValue(
                            "@ContentType", "Comment");

                        moderationCmd.Parameters.AddWithValue(
                            "@ContentText", commentText);

                        moderationCmd.Parameters.AddWithValue(
                            "@Category", result.Category);

                        moderationCmd.Parameters.AddWithValue(
                            "@IsSafe", true);

                        moderationCmd.Parameters.AddWithValue(
                            "@Reason", result.Reason);

                        moderationCmd.Parameters.AddWithValue(
                            "@TweetId", tweetId);

                        moderationCmd.Parameters.AddWithValue(
                            "@CommentId", commentId);

                        moderationCmd.ExecuteNonQuery();
                    }

                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();

                    ShowMessage(
                        "Unable to add your comment. " +
                        Server.HtmlEncode(ex.Message),
                        "danger"
                    );

                    return;
                }
            }

            txtComment.Text = "";

            ShowMessage(
                "Comment added and passed the content safety check!",
                "success"
            );

            LoadTweets();
        }

        private string CurrentFeed
        {
            get
            {
                return ViewState["CurrentFeed"]?.ToString() ?? "ForYou";
            }
            set
            {
                ViewState["CurrentFeed"] = value;
            }
        }
        private void LoadComments(int tweetId)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
            SELECT
                c.CommentId,
                c.CommentText,
                c.CreatedAt,
                u.Username
            FROM Comments c
            INNER JOIN Users u
                ON c.Email = u.Email
            WHERE c.TweetId = @TweetId
            ORDER BY c.CreatedAt ASC";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue(
                        "@TweetId",
                        tweetId
                    );

                    SqlDataAdapter da =
                        new SqlDataAdapter(cmd);

                    DataTable dt =
                        new DataTable();

                    da.Fill(dt);

                    rptComments.DataSource = dt;
                    rptComments.DataBind();

                    pnlNoComments.Visible =
                        dt.Rows.Count == 0;
                }
            }
        }

        protected void btnViewComments_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hdnCommentTweetId.Value))
                return;

            int tweetId =
                Convert.ToInt32(hdnCommentTweetId.Value);

            LoadComments(tweetId);

            ClientScript.RegisterStartupScript(
                this.GetType(),
                "openComments",
                "document.getElementById('commentModalOverlay').classList.add('show');",
                true
            );
        }

        protected void btnSubmitLike_Click(object sender, EventArgs e)
        {
            string email = Session["Email"].ToString();
            int tweetId = Convert.ToInt32(hdnLikeTweetId.Value);

            SqlConnection con = new SqlConnection(strcon);
            // Check if already liked
            SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM Likes WHERE TweetId=@TweetId AND Email=@Email", con);
            check.Parameters.AddWithValue("@TweetId", tweetId);
            check.Parameters.AddWithValue("@Email", email);
            con.Open();
            int exists = (int)check.ExecuteScalar();

            if (exists == 0)
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Likes (TweetId, Email) VALUES (@TweetId, @Email)", con);
                cmd.Parameters.AddWithValue("@TweetId", tweetId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
            else
            {
                // Unlike if already liked
                SqlCommand cmd = new SqlCommand("DELETE FROM Likes WHERE TweetId=@TweetId AND Email=@Email", con);
                cmd.Parameters.AddWithValue("@TweetId", tweetId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
            con.Close();
            LoadTweets();
        }

        protected void btnSubmitRepost_Click(object sender, EventArgs e)
        {
            string email = Session["Email"].ToString();
            int tweetId = Convert.ToInt32(hdnRepostTweetId.Value);

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM Retweets WHERE TweetId=@TweetId AND Email=@Email", con);
            check.Parameters.AddWithValue("@TweetId", tweetId);
            check.Parameters.AddWithValue("@Email", email);
            con.Open();
            int exists = (int)check.ExecuteScalar();

            if (exists == 0)
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Retweets (TweetId, Email, RetweetedAt) VALUES (@TweetId, @Email, GETDATE())", con);
                cmd.Parameters.AddWithValue("@TweetId", tweetId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
            else
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Retweets WHERE TweetId=@TweetId AND Email=@Email", con);
                cmd.Parameters.AddWithValue("@TweetId", tweetId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
            con.Close();
            LoadTweets();
        }
    }
}
