<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProfilePage.aspx.cs" Inherits="EliteTweet.ProfilePage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Profile / EliteTweet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        * { box-sizing: border-box; }

        body {
            background-color: #000;
            color: #fff;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            margin: 0;
        }

        .page-wrapper {
            display: flex;
            width: 100%;
            max-width: 1280px;
            margin: 0 auto;
            align-items: flex-start;
        }

        .left-sidebar {
            width: 275px;
            min-height: 100vh;
            padding: 8px 12px;
            position: sticky;
            top: 0;
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            flex-shrink: 0;
        }

        .main-profile {
            flex: 1;
            min-width: 0;
            min-height: 100vh;
            border-left: 1px solid #2f3336;
            border-right: 1px solid #2f3336;
        }

        .x-logo {
            font-size: 28px;
            padding: 10px 14px;
            border-radius: 50%;
            display: inline-block;
            cursor: pointer;
            transition: background 0.2s;
            margin-bottom: 4px;
        }
        .x-logo:hover { background: #1a1a1a; }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 12px 14px;
            border-radius: 30px;
            font-size: 19px;
            font-weight: 400;
            cursor: pointer;
            color: #fff;
            text-decoration: none;
            transition: background 0.2s;
            white-space: nowrap;
        }
        .nav-item:hover { background: #1a1a1a; color: #fff; }
        .nav-item.active { font-weight: 700; }
        .nav-item i { font-size: 22px; min-width: 26px; }

        .btn-post-sidebar {
            background-color: #1d9bf0;
            color: #fff;
            border: none;
            border-radius: 30px;
            font-size: 17px;
            font-weight: 700;
            padding: 14px;
            width: 100%;
            margin-top: 16px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-post-sidebar:hover { background-color: #1a8cd8; }

        .user-profile-bottom {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            border-radius: 30px;
            margin-top: auto;
            margin-bottom: 8px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .user-profile-bottom:hover { background: #1a1a1a; }

        .user-avatar-sm {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #536471;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #fff;
            flex-shrink: 0;
        }

        .user-info-name  { font-weight: 700; font-size: 15px; line-height: 1.3; }
        .user-info-handle { color: #71767b; font-size: 14px; }

        .profile-topbar {
            position: sticky;
            top: 0;
            background: rgba(0,0,0,0.85);
            backdrop-filter: blur(12px);
            z-index: 10;
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 10px 16px;
            border-bottom: 1px solid #2f3336;
        }

        .back-btn {
            background: none;
            border: none;
            color: #fff;
            font-size: 20px;
            cursor: pointer;
            padding: 6px 8px;
            border-radius: 50%;
            transition: background 0.2s;
        }
        .back-btn:hover { background: #1a1a1a; }

        .topbar-info { line-height: 1.3; }
        .topbar-name  { font-size: 17px; font-weight: 700; }
        .topbar-posts { font-size: 13px; color: #71767b; }

        .cover-photo {
            width: 100%;
            height: 180px;
            background: #333639;
            position: relative;
        }

        .profile-avatar-wrap {
            position: absolute;
            bottom: -52px;
            left: 16px;
        }

        .profile-avatar {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            background: #536471;
            border: 4px solid #000;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 52px;
            color: #fff;
            overflow: hidden;
        }
        
        .profile-actions {
            display: flex;
            justify-content: flex-end;
            padding: 12px 16px;
            min-height: 60px;
        }

        .btn-setup-profile {
            background: transparent;
            color: #fff;
            border: 1px solid #536471;
            border-radius: 20px;
            padding: 7px 18px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-setup-profile:hover { background: rgba(255,255,255,0.1); }
       
        .profile-info {
            padding: 40px 16px 12px;
        }

        .profile-name {
            font-size: 20px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .verified-badge { color: #1d9bf0; font-size: 18px; }

        .profile-handle { color: #71767b; font-size: 15px; margin-bottom: 10px; }

        .profile-meta {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #71767b;
            font-size: 14px;
            margin-bottom: 12px;
        }

        .follow-counts {
            display: flex;
            gap: 20px;
            font-size: 15px;
            margin-bottom: 4px;
        }

        .follow-counts a {
            color: #fff;
            text-decoration: none;
        }
        .follow-counts a:hover { text-decoration: underline; }
        .follow-counts span { color: #71767b; }

        .verify-banner {
            margin: 12px 16px;
            background: #1e3a2f;
            border-radius: 12px;
            padding: 14px 16px;
            position: relative;
        }

        .verify-banner-title {
            font-size: 16px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 4px;
        }

        .verify-banner-text {
            font-size: 14px;
            color: #8899a6;
            margin-bottom: 12px;
        }

        .btn-get-verified {
            background: #fff;
            color: #000;
            border: none;
            border-radius: 20px;
            padding: 8px 18px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-get-verified:hover { background: #e7e9ea; }

        .verify-close {
            position: absolute;
            top: 10px;
            right: 12px;
            background: none;
            border: none;
            color: #71767b;
            font-size: 18px;
            cursor: pointer;
            border-radius: 50%;
            padding: 4px 6px;
            transition: background 0.2s;
        }
        .verify-close:hover { background: rgba(255,255,255,0.1); }

        .verified-banner {
            margin: 12px 16px;
            background: #1a3a5c;
            border-radius: 12px;
            padding: 14px 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 15px;
            font-weight: 600;
        }

        .profile-tabs {
            display: flex;
            border-bottom: 1px solid #2f3336;
            margin-top: 4px;
            overflow-x: auto;
        }
        .profile-tabs::-webkit-scrollbar { height: 0; }

        .profile-tab {
            flex: 1;
            text-align: center;
            padding: 14px 8px;
            font-size: 14px;
            font-weight: 500;
            color: #71767b;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            white-space: nowrap;
            transition: background 0.15s;
            min-width: 80px;
        }
        .profile-tab:hover { background: #0a0a0a; color: #fff; }
        .profile-tab.active { color: #fff; font-weight: 700; border-bottom-color: #1d9bf0; }

        .tweet-card {
            display: flex;
            gap: 12px;
            padding: 12px 16px;
            border-bottom: 1px solid #2f3336;
            transition: background 0.2s;
            cursor: pointer;
        }
        .tweet-card:hover { background: #080808; }

        .tweet-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #536471;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #fff;
            flex-shrink: 0;
        }

        .tweet-content { flex: 1; }

        .tweet-header {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 2px;
            flex-wrap: wrap;
        }

        .tweet-name   { font-weight: 700; font-size: 15px; }
        .tweet-handle { color: #71767b; font-size: 14px; }
        .tweet-dot    { color: #71767b; }
        .tweet-time   { color: #71767b; font-size: 14px; }

        .tweet-text {
            font-size: 15px;
            line-height: 1.5;
            color: #e7e9ea;
            margin-bottom: 10px;
        }

        .tweet-actions {
            display: flex;
            gap: 28px;
            color: #71767b;
            font-size: 13px;
        }

        .tweet-action {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            padding: 4px 6px;
            border-radius: 20px;
            transition: color 0.2s, background 0.2s;
        }
        .tweet-action:hover { color: #1d9bf0; background: rgba(29,155,240,0.1); }
        .tweet-action i { font-size: 16px; }

        .tweet-more {
            background: none;
            border: none;
            color: #71767b;
            font-size: 18px;
            padding: 4px 8px;
            border-radius: 50%;
            cursor: pointer;
            margin-left: auto;
            transition: background 0.2s, color 0.2s;
        }
        .tweet-more:hover { background: rgba(29,155,240,0.1); color: #1d9bf0; }

        .empty-tab {
            text-align: center;
            padding: 48px 20px;
            color: #71767b;
            font-size: 15px;
        }
        .empty-tab h3 { color: #fff; font-size: 22px; font-weight: 800; margin-bottom: 8px; }

        ::-webkit-scrollbar { width: 0px; }

        .media-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2px;
        }

        .media-card {
            aspect-ratio: 1 / 1;
            overflow: hidden;
            background: #000;
        }

        .media-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .media-card img:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="page-wrapper">

    <!-- ════════════ LEFT SIDEBAR ════════════ -->
    <div class="left-sidebar">
        <div class="x-logo"><i class="bi bi-twitter-x"></i></div>

        <a class="nav-item" href="HomePage.aspx"><i class="bi bi-house-fill"></i> Home</a>
        <a class="nav-item" href="Explore.aspx">
            <i class="bi bi-search"></i> Explore
        </a>
        <a class="nav-item" href="Notifications.aspx">
            <i class="bi bi-bell"></i> Notifications
        </a>        
        <a class="nav-item" href="#"><i class="bi bi-people"></i> Follow</a>
        <a class="nav-item" href="Bookmarks.aspx">
            <i class="bi bi-bookmark"></i> Bookmarks
        </a>
        <a class="nav-item active" href="ProfilePage.aspx"><i class="bi bi-person"></i> Profile</a>
        <a class="nav-item" href="FirstPage.aspx"><i class="bi bi-box-arrow-right"></i> Log out</a>

        <button class="btn-post-sidebar" onclick="window.location.href='HomePage.aspx'; return false;">Post</button>

        <div class="user-profile-bottom">
            <div class="user-avatar-sm"><i class="bi bi-person-fill"></i></div>
            <div class="flex-grow-1">
                <div class="user-info-name"><asp:Label ID="lblSidebarName" runat="server" /></div>
                <div class="user-info-handle"><asp:Label ID="lblSidebarUsername" runat="server" /></div>
            </div>
            <%--<i class="bi bi-three-dots" style="color:#71767b;"></i>--%>
        </div>
    </div>

    <!-- ════════════ MAIN PROFILE COLUMN ════════════ -->
    <div class="main-profile">

        <div class="profile-topbar">
            <button class="back-btn" onclick="history.back(); return false;">
                <i class="bi bi-arrow-left"></i>
            </button>
            <div class="topbar-info">
                <div class="topbar-name">
                    <asp:Label ID="lblTopName" runat="server" />
                    <asp:Label ID="lblTopVerified" runat="server" />
                </div>
                <div class="topbar-posts">
                    <asp:Label ID="lblTopPostCount" runat="server" Text="0 posts" />
                </div>
            </div>
        </div>

        <div class="cover-photo" style="position:relative;">
            <asp:Image ID="imgCover" runat="server"
                Style="width:100%;height:100%;object-fit:cover;"
                Visible="false" />

            <div class="profile-avatar-wrap">
                <div class="profile-avatar">
                    <asp:Image ID="imgProfile" runat="server"
                        Style="width:100%;height:100%;object-fit:cover;border-radius:50%;"
                        Visible="false" />

                    <asp:Panel ID="pnlDefaultAvatar" runat="server">
                        <i class="bi bi-person-fill"></i>
                    </asp:Panel>
                </div>
            </div>
        </div>

        <div class="profile-actions">
            <asp:Panel ID="pnlEditProfile" runat="server">
                <button type="button" class="btn-setup-profile"
                    onclick="document.getElementById('editProfileBox').style.display='block'">
                    Edit profile
                </button>
            </asp:Panel>

            <asp:Panel ID="pnlFollowProfile" runat="server" Visible="false">
                <asp:Button ID="btnProfileFollow" runat="server"
                    CssClass="btn-setup-profile"
                    OnClick="btnProfileFollow_Click" />
            </asp:Panel>
        </div>

        <div id="editProfileBox" style="display:none;padding:20px;border-bottom:1px solid #2f3336;">
            <h4>Edit profile</h4>

            <p>Profile picture</p>
            <asp:FileUpload ID="uploadProfile" runat="server" accept="image/*" />

            <p style="margin-top:15px;">Cover photo</p>
            <asp:FileUpload ID="uploadCover" runat="server" accept="image/*" />

            <p style="margin-top:15px;">Bio</p>
            <asp:TextBox ID="txtBio" runat="server"
                TextMode="MultiLine" MaxLength="160"
                Style="width:100%;background:#202327;color:white;border:1px solid #536471;border-radius:8px;padding:10px;" />

            <asp:Button ID="btnSaveProfile" runat="server"
                Text="Save changes"
                CssClass="btn-setup-profile"
                Style="margin-top:15px;"
                OnClick="btnSaveProfile_Click" />

            <asp:Label ID="lblProfileMessage" runat="server"
                Style="display:block;margin-top:10px;" />
        </div>

        <div class="profile-info">
            <div class="profile-name">
                <asp:Label ID="lblName" runat="server" />
                <asp:Label ID="lblVerifiedBadge" runat="server" />
            </div>
            <div class="profile-handle">
                <asp:Label ID="lblUsername" runat="server" />
            </div>
            <div style="padding-bottom:12px;">
                <asp:Label ID="lblBio" runat="server" />
            </div>
            <div class="profile-meta">
                <i class="bi bi-calendar3"></i>
                <asp:Label ID="lblJoined" runat="server" Text="Joined" />
            </div>
            <div class="follow-counts">
                <a href="#">
                    <strong><asp:Label ID="lblFollowingCount" runat="server" Text="0" /></strong>
                    <span> Following</span>
                </a>
                <a href="#">
                    <strong><asp:Label ID="lblFollowerCount" runat="server" Text="0" /></strong>
                    <span> Followers</span>
                </a>
            </div>
        </div>

        <asp:Panel ID="pnlNotVerified" runat="server" CssClass="verify-banner">
            <button class="verify-close" onclick="this.parentElement.style.display='none'; return false;">
                <i class="bi bi-x"></i>
            </button>
            <div class="verify-banner-title">
                You aren't verified yet
                <i class="bi bi-patch-check-fill" style="color:#1d9bf0;"></i>
            </div>
            <div class="verify-banner-text">
                Get verified for boosted replies, analytics, ad-free browsing, and more. Upgrade your profile now.
            </div>
            <button class="btn-get-verified">Get verified</button>
        </asp:Panel>

        <asp:Panel ID="pnlVerified" runat="server" CssClass="verified-banner" Visible="false">
            <i class="bi bi-patch-check-fill" style="color:#1d9bf0;font-size:22px;"></i>
            <span>Verified account</span>
        </asp:Panel>

        <div class="profile-tabs">
            <div class="profile-tab active" onclick="showTab('posts', this)">Posts</div>
            <div class="profile-tab" onclick="showTab('replies', this)">Replies</div>
            <div class="profile-tab" onclick="showTab('media', this)">Media</div>
            <div class="profile-tab" onclick="showTab('likes', this)">Likes</div>
        </div>

        <div id="tab-posts">
            <asp:Repeater ID="rptPosts" runat="server">
                <ItemTemplate>
                    <div class="tweet-card">
                        <div class="tweet-avatar"><i class="bi bi-person-fill"></i></div>
                        <div class="tweet-content">
                            <div class="tweet-header">
                                <span class="tweet-name"><%# Eval("Name") %></span>
                                <%# Convert.ToBoolean(Eval("IsVerified")) ? "<i class=\"bi bi-patch-check-fill\" style=\"color:#1d9bf0;\"></i>" : "" %>
                                <span class="tweet-handle">@<%# Eval("Username") %></span>
                                <span class="tweet-dot">&middot;</span>
                                <span class="tweet-time"><%# Eval("CreatedAt") %></span>
                                <button class="tweet-more"><i class="bi bi-three-dots"></i></button>
                            </div>
                            <div class="tweet-text"><%# Eval("TweetText") %></div>
                            <div class="tweet-actions">
                                <div class="tweet-action"><i class="bi bi-chat"></i><span><%# Eval("CommentCount") %></span></div>
                                <div class="tweet-action"><i class="bi bi-arrow-repeat"></i><span><%# Eval("RetweetCount") %></span></div>
                                <div class="tweet-action"><i class="bi bi-heart"></i><span><%# Eval("LikeCount") %></span></div>
                                <div class="tweet-action"><i class="bi bi-bar-chart"></i><span>0</span></div>
                                <div class="tweet-action"><i class="bi bi-upload"></i></div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoPosts" runat="server" Visible="false">
                <div class="empty-tab">
                    <h3>No posts yet</h3>
                    <p>When you post, it'll show up here.</p>
                </div>
            </asp:Panel>
        </div>

        <div id="tab-replies" style="display:none;">
            <asp:Repeater ID="rptReplies" runat="server">
                <ItemTemplate>
                    <div class="tweet-card">
                        <div class="tweet-avatar"><i class="bi bi-person-fill"></i></div>
                        <div class="tweet-content">
                            <div class="tweet-header">
                                <span class="tweet-name"><%# Eval("Name") %></span>
                                <%# Convert.ToBoolean(Eval("IsVerified")) ? "<i class=\"bi bi-patch-check-fill\" style=\"color:#1d9bf0;\"></i>" : "" %>
                                <span class="tweet-handle">@<%# Eval("Username") %></span>
                                <span class="tweet-dot">&middot;</span>
                                <span class="tweet-time"><%# Eval("CreatedAt") %></span>
                            </div>
                            <div class="tweet-text" style="color:#71767b; font-size:13px; margin-bottom:4px;">
                                Replying to <span style="color:#1d9bf0;">@<%# Eval("TweetAuthor") %></span>
                            </div>
                            <div style="border: 1px solid #2f3336; border-radius: 12px; padding: 10px; margin-bottom: 8px; color: #71767b; font-size: 14px;">
                                <%# Eval("TweetText") %>
                            </div>
                            <div class="tweet-text"><%# Eval("CommentText") %></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoReplies" runat="server" Visible="false">
                <div class="empty-tab">
                    <h3>No replies yet</h3>
                    <p>Replies will show here.</p>
                </div>
            </asp:Panel>
        </div>

        <div id="tab-media" style="display:none;">
            <div class="media-grid">
                <asp:Repeater ID="rptMedia" runat="server">
                    <ItemTemplate>
                        <div class="media-card">
                            <img src='<%# ResolveUrl("~/" + Eval("ImagePath").ToString()) %>'
                                 alt="Post image"
                                 onclick="window.open(this.src, '_blank');" />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlNoMedia" runat="server" Visible="false">
                <div class="empty-tab">
                    <h3>No media yet</h3>
                    <p>Photos will show here.</p>
                </div>
            </asp:Panel>
        </div>  

        <div id="tab-likes" style="display:none;">
            <asp:Repeater ID="rptLikes" runat="server">
                <ItemTemplate>
                    <div class="tweet-card">
                        <div class="tweet-avatar"><i class="bi bi-person-fill"></i></div>
                        <div class="tweet-content">
                            <div class="tweet-header">
                                <span class="tweet-name"><%# Eval("Name") %></span>
                                <%# Convert.ToBoolean(Eval("IsVerified")) ? "<i class=\"bi bi-patch-check-fill\" style=\"color:#1d9bf0;\"></i>" : "" %>
                                <span class="tweet-handle">@<%# Eval("Username") %></span>
                                <span class="tweet-dot">&middot;</span>
                                <span class="tweet-time"><%# Eval("CreatedAt") %></span>
                            </div>
                            <div class="tweet-text"><%# Eval("TweetText") %></div>
                            <div class="tweet-actions">
                                <div class="tweet-action"><i class="bi bi-chat"></i><span><%# Eval("CommentCount") %></span></div>
                                <div class="tweet-action"><i class="bi bi-arrow-repeat"></i><span><%# Eval("RetweetCount") %></span></div>
                                <div class="tweet-action" style="color:#f91880;"><i class="bi bi-heart-fill"></i><span><%# Eval("LikeCount") %></span></div>
                                <div class="tweet-action"><i class="bi bi-bar-chart"></i><span>0</span></div>
                                <div class="tweet-action"><i class="bi bi-upload"></i></div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoLikes" runat="server" Visible="false">
                <div class="empty-tab">
                    <h3>No likes yet</h3>
                    <p>Tweets you like will show up here.</p>
                </div>
            </asp:Panel>
        </div>

    </div>

</div>
</form>

<script>
    function showTab(tabName, el) {
        ['posts', 'replies', 'highlights', 'articles', 'media', 'likes'].forEach(function (t) {
            var el = document.getElementById('tab-' + t);
            if (el) el.style.display = 'none';
        });
        document.querySelectorAll('.profile-tab').forEach(function (t) {
            t.classList.remove('active');
        });
        document.getElementById('tab-' + tabName).style.display = 'block';
        el.classList.add('active');
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
