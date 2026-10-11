<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Async="true" Inherits="EliteTweet.HomePage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home / EliteTweet</title>
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

        .main-feed {
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

        .user-avatar {
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

        .user-info-name {
            font-weight: 700;
            font-size: 15px;
            line-height: 1.3;
        }
        .user-info-handle {
            color: #71767b;
            font-size: 14px;
        }

/*        .main-feed {
            width: 600px;
            min-height: 100vh;
            border-left: 1px solid #2f3336;
            border-right: 1px solid #2f3336;
        }
*/
        .feed-header {
            position: sticky;
            top: 0;
            background: rgba(0,0,0,0.85);
            backdrop-filter: blur(12px);
            z-index: 10;
            display: flex;
            border-bottom: 1px solid #2f3336;
        }

        .feed-tab {
            flex: 1;
            text-align: center;
            padding: 16px;
            font-size: 15px;
            font-weight: 500;
            color: #71767b;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: background 0.2s;
        }
        .feed-tab:hover { background: #0a0a0a; }
        .feed-tab.active {
            color: #fff;
            font-weight: 700;
            border-bottom-color: #1d9bf0;
        }

        .composer-box {
            display: flex;
            gap: 12px;
            padding: 12px 16px;
            border-bottom: 1px solid #2f3336;
        }

        .composer-right {
            flex: 1;
        }

        .composer-textarea {
            width: 100%;
            background: transparent;
            border: none;
            color: #fff;
            font-size: 19px;
            resize: none;
            outline: none;
            min-height: 52px;
            padding-top: 6px;
        }
        .composer-textarea::placeholder { color: #71767b; }

        .composer-divider {
            border: none;
            border-top: 1px solid #2f3336;
            margin: 8px 0;
        }

        .composer-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .composer-icons {
            display: flex;
            gap: 4px;
        }

        .composer-icon-btn {
            background: none;
            border: none;
            color: #1d9bf0;
            font-size: 18px;
            padding: 8px;
            border-radius: 50%;
            cursor: pointer;
            transition: background 0.2s;
        }
        .composer-icon-btn:hover { background: rgba(29,155,240,0.1); }

        .btn-post {
            background-color: #1d9bf0;
            color: #fff;
            border: none;
            border-radius: 20px;
            padding: 8px 18px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-post:hover { background-color: #1a8cd8; }
        .btn-post:disabled { opacity: 0.5; cursor: not-allowed; }

        .show-posts-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 14px;
            border-bottom: 1px solid #2f3336;
            color: #1d9bf0;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .show-posts-bar:hover { background: #050505; }

        .tweet-card {
            display: flex;
            gap: 12px;
            padding: 12px 16px;
            border-bottom: 1px solid #2f3336;
            transition: background 0.2s;
            cursor: pointer;
        }
        .tweet-card:hover { background: #080808; }

        .tweet-content { flex: 1; }

        .tweet-header {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 2px;
            flex-wrap: wrap;
        }

        .tweet-name {
            font-weight: 700;
            font-size: 15px;
        }

        .verified-badge {
            color: #1d9bf0;
            font-size: 15px;
        }

        .tweet-handle {
            color: #71767b;
            font-size: 14px;
        }

        .tweet-dot { color: #71767b; }

        .tweet-time {
            color: #71767b;
            font-size: 14px;
        }

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

        .right-sidebar {
            width: 350px;
            padding: 12px 16px;
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
        }

        .search-bar {
            position: relative;
            margin-bottom: 16px;
        }
        .search-bar input {
            width: 100%;
            background: #202327;
            border: 1px solid transparent;
            border-radius: 30px;
            color: #fff;
            padding: 10px 16px 10px 44px;
            font-size: 15px;
            outline: none;
            transition: border-color 0.2s, background 0.2s;
        }
        .search-bar input:focus {
            background: #000;
            border-color: #1d9bf0;
        }
        .search-bar input::placeholder { color: #71767b; }
        .search-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #71767b;
            font-size: 17px;
        }

        .sidebar-card {
            background: #16181c;
            border-radius: 16px;
            padding: 16px;
            margin-bottom: 16px;
        }

        .sidebar-card h5 {
            font-size: 19px;
            font-weight: 800;
            margin-bottom: 12px;
        }

        .news-item {
            padding: 10px 0;
            border-bottom: 1px solid #2f3336;
            cursor: pointer;
        }
        .news-item:last-child { border-bottom: none; }
        .news-item:hover { opacity: 0.8; }

        .news-item-title {
            font-size: 14px;
            font-weight: 700;
            line-height: 1.4;
            margin-bottom: 2px;
        }

        .news-item-meta {
            font-size: 12px;
            color: #71767b;
        }

        .trending-item {
            padding: 10px 0;
            border-bottom: 1px solid #2f3336;
            cursor: pointer;
        }
        .trending-item:last-child { border-bottom: none; }
        .trending-item:hover { background: rgba(255,255,255,0.03); }

        .trending-category {
            font-size: 12px;
            color: #71767b;
        }

        .trending-tag {
            font-size: 15px;
            font-weight: 700;
        }

        .trending-count {
            font-size: 12px;
            color: #71767b;
        }

        .show-more-link {
            color: #1d9bf0;
            font-size: 14px;
            cursor: pointer;
            padding-top: 8px;
            display: block;
        }
        .show-more-link:hover { text-decoration: underline; }

        .alert-tweet {
            margin: 8px 16px;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 14px;
        }

        .empty-feed {
            text-align: center;
            padding: 40px 20px;
            color: #71767b;
            font-size: 16px;
        }

        ::-webkit-scrollbar { width: 0px; }

        .tweet-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(91,112,131,0.4);
            z-index: 1000;
            justify-content: center;
            align-items: flex-start;
            padding-top: 60px;
        }
        .tweet-modal-overlay.show {
            display: flex;
        }

        .tweet-modal {
            background: #000;
            border-radius: 16px;
            width: 100%;
            max-width: 580px;
            padding: 12px 16px 16px;
            position: relative;
            animation: modalIn 0.18s ease;
        }

        @keyframes modalIn {
            from { opacity: 0; transform: translateY(-20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .modal-top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .modal-close-btn {
            background: none;
            border: none;
            color: #fff;
            font-size: 20px;
            cursor: pointer;
            padding: 6px;
            border-radius: 50%;
            transition: background 0.2s;
            line-height: 1;
        }
        .modal-close-btn:hover { background: #1a1a1a; }

        .modal-drafts {
            color: #1d9bf0;
            font-size: 15px;
            font-weight: 600;
            background: none;
            border: none;
            cursor: pointer;
        }

        .modal-body {
            display: flex;
            gap: 12px;
        }

        .modal-textarea {
            width: 100%;
            background: transparent;
            border: none;
            color: #fff;
            font-size: 19px;
            resize: none;
            outline: none;
            min-height: 120px;
            padding-top: 4px;
        }
        .modal-textarea::placeholder { color: #71767b; }

        .modal-reply-note {
            color: #1d9bf0;
            font-size: 14px;
            margin: 10px 0 6px 52px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .modal-divider {
            border: none;
            border-top: 1px solid #2f3336;
            margin: 10px 0;
        }

        .modal-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-icons {
            display: flex;
            gap: 2px;
            margin-left: 52px;
        }

       
    .report-modal-overlay {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(91,112,131,0.4);
        z-index: 2000;
        justify-content: center;
        align-items: center;
    }
    .report-modal-overlay.show { display: flex; }
    .report-modal {
        background: #1a1a1a;
        border-radius: 16px;
        width: 100%;
        max-width: 380px;
        padding: 20px;
        animation: modalIn 0.18s ease;
    }
    .report-option {
        display: block;
        width: 100%;
        background: none;
        border: 1px solid #2f3336;
        color: #fff;
        padding: 10px 14px;
        border-radius: 8px;
        margin-bottom: 8px;
        text-align: left;
        font-size: 14px;
        cursor: pointer;
        transition: background 0.2s;
    }
    .report-option:hover { background: #2f3336; }

    .comment-modal-overlay {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.6);
    z-index: 2000;
    justify-content: center;
    align-items: center;
    }
    .comment-modal-overlay.show { display: flex; }
    .comment-modal {
        background: #1a1a1a;
        border-radius: 12px;
        width: 100%;
        max-width: 500px;
        padding: 20px;
    }

    .tweet-image-wrap {
        margin-top: 10px;
        border-radius: 16px;
        overflow: hidden;
        border: 1px solid #2f3336;
        max-width: 550px;
    }

    .tweet-image {
        width: 100%;
        max-height: 400px;
        object-fit: contain;
        display: block;
    }

    .alert-tweet {
    position: relative;
    padding: 14px 50px 14px 16px;
}

.alert-message-text {
    display: block;
}

.alert-close-btn {
    position: absolute;
    top: 50%;
    right: 12px;
    transform: translateY(-50%);

    width: 32px;
    height: 32px;

    border: none;
    background: transparent;

    color: inherit;
    font-size: 24px;
    line-height: 32px;

    cursor: pointer;
    z-index: 99999;

    display: flex;
    align-items: center;
    justify-content: center;
}

.alert-close-btn:hover {
    opacity: 0.6;
}

    .feed-tab {
        text-decoration: none;
        border: none;
        background: transparent;
    }



    .tweet-action.liked {
        color: #f91880;
    }

    .tweet-action.liked i {
        color: #f91880;
    }

    .tweet-action.liked:hover {
        color: #f91880;
        background: rgba(249, 24, 128, 0.1);
    }

    </style>
</head>
<body>
<form id="form1" runat="server" enctype="multipart/form-data">
<div class="page-wrapper">
 
    <!-- ============= LEFT SIDEBAR ============= -->
    <div class="left-sidebar">

        <div class="x-logo">
            <i class="bi bi-twitter-x"></i>
        </div>

        <a class="nav-item active" href="HomePage.aspx">
            <i class="bi bi-house-fill"></i> Home
        </a>
        <a class="nav-item" href="Explore.aspx">
            <i class="bi bi-search"></i> Explore
        </a>
        <a class="nav-item" href="Notifications.aspx">
            <i class="bi bi-bell"></i> Notifications
        </a>
        <a class="nav-item" href="Follow.aspx?tab=following">
            <i class="bi bi-people"></i> Follow
        </a>
        <%--<a class="nav-item" href="#">
            <i class="bi bi-envelope"></i> Chat
        </a>--%>
        <a class="nav-item" href="Bookmarks.aspx">
            <i class="bi bi-bookmark"></i> Bookmarks
        </a>
        <a class="nav-item" href="ProfilePage.aspx">
            <i class="bi bi-person"></i> Profile
        </a>
        
        <a id="lnkLogout" runat="server" class="nav-item" OnServerClick="lnkLogout_ServerClick">
            <i class="bi bi-three-dots"></i> LogOut
        </a>


        <button class="btn-post-sidebar" onclick="openTweetModal(); return false;">
            Post
        </button>


        <div class="user-profile-bottom">
            <div class="user-avatar">
                <i class="bi bi-person-fill"></i>
            </div>
            <div class="flex-grow-1">
                <div class="user-info-name">
                    <asp:Label ID="lblName" runat="server" Text="User" />
                </div>
                <div class="user-info-handle">
                    <asp:Label ID="lblUsername" runat="server" Text="@username" />
                </div>
            </div>
            <%--<i class="bi bi-three-dots" style="color:#71767b;"></i>--%>
        </div>

    </div>

    <!-- ============= MAIN FEED ============= -->
    <div class="main-feed">

     
        <div class="feed-header">
            <asp:LinkButton ID="btnForYou" runat="server"
                CssClass="feed-tab active"
                OnClick="btnForYou_Click">
                For you
            </asp:LinkButton>

            <asp:LinkButton ID="btnFollowing" runat="server"
                CssClass="feed-tab"
                OnClick="btnFollowing_Click">
                Following
            </asp:LinkButton>
    </div>

  
        <div id="messageContainer" runat="server"
             class="alert-tweet"
             visible="false">

            <asp:Label
                ID="lblMessage"
                runat="server" />

        </div>

 
        <div class="composer-box">
            <div class="user-avatar" style="width:44px;height:44px;font-size:20px;flex-shrink:0;">
                <i class="bi bi-person-fill"></i>
            </div>
            <div class="composer-right">
                <asp:TextBox
                    ID="txtTweet"
                    runat="server"
                    TextMode="MultiLine"
                    CssClass="composer-textarea"
                    placeholder="What's happening?"
                    ClientIDMode="Static"
                    Rows="2"
                    MaxLength="280" />

                <hr class="composer-divider" />

                <asp:FileUpload ID="fileUpload" runat="server" ClientIDMode="Static" accept="image/*" style="display:none;" />
                <div id="inlineImagePreviewWrap" style="display:none; margin:8px 0; position:relative; max-width:260px;">
                    <img id="inlineImagePreview" src="" style="max-width:100%; border-radius:16px; display:block; border:1px solid #2f3336;" />
                    <button type="button" onclick="clearInlineImage(); return false;"
                        style="position:absolute; top:6px; right:6px; background:rgba(0,0,0,0.75); color:#fff; border:none; border-radius:50%; width:26px; height:26px; cursor:pointer;">&times;</button>
                </div>

                <div class="composer-actions">
                    <div class="composer-icons">
                        <button type="button" class="composer-icon-btn" title="Media" onclick="document.getElementById('fileUpload').click(); return false;">
                            <i class="bi bi-image"></i>
                        </button>
                    </div>

                    <asp:Button
                        ID="btnPost"
                        runat="server"
                        Text="Post"
                        CssClass="btn-post"
                        OnClick="btnPost_Click" />
                </div>
            </div>
        </div>

        <%--<!-- Show posts count bar -->
        <div class="show-posts-bar" onclick="window.location.reload();">
            <asp:Label ID="lblPostCount" runat="server" Text="Show posts" />
        </div>--%>

    
        <asp:Repeater ID="rptTweets" runat="server">
            <ItemTemplate>
                <div class="tweet-card">
                    <div class="user-avatar" style="width:44px;height:44px;font-size:20px;flex-shrink:0;">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="tweet-content">
                        <div class="tweet-header">
                            <span class="tweet-name"><%# Eval("Name") %></span>
                            <%# (bool)Eval("IsVerified") ? "<i class=\"bi bi-patch-check-fill verified-badge\"></i>" : "" %>
                            <span class="tweet-handle">@<%# Eval("Username") %></span>
                            <span class="tweet-dot">&middot;</span>
                            <span class="tweet-time"><%# GetTimeAgo((DateTime)Eval("CreatedAt")) %></span>
                            <button class="tweet-more" onclick="openReportModal('<%# Eval("TweetId") %>'); return false;">
                                <i class="bi bi-three-dots"></i>
                            </button>
                        </div>
                        <div class="tweet-text"><%# Eval("TweetText") %></div>
                        <%# RenderTweetImage(Eval("ImagePath")) %>
                        <div class="tweet-actions">
                            <div class="tweet-action" onclick="viewComments('<%# Eval("TweetId") %>'); return false;">
                                <i class="bi bi-chat"></i>
                                <span><%# Eval("CommentCount") %></span>
                            </div>
                            <div class="tweet-action" onclick="submitRepost('<%# Eval("TweetId") %>')">
                                <i class="bi bi-arrow-repeat"></i>
                                <span><%# Eval("RetweetCount") %></span>
                            </div>
                            <div class='<%# Convert.ToInt32(Eval("IsLiked")) == 1 ? "tweet-action liked" : "tweet-action" %>' onclick="submitLike('<%# Eval("TweetId") %>')">
                                <i class='<%# Convert.ToInt32(Eval("IsLiked")) == 1 ? "bi bi-heart-fill" : "bi bi-heart" %>'></i>
                                <span><%# Eval("LikeCount") %></span>
                            </div>
                            <%--<div class="tweet-action">
                                <i class="bi bi-bar-chart"></i>
                                <span>0</span>
                            </div>--%>
                            <div class="tweet-action"
                                 onclick="submitBookmark('<%# Eval("TweetId") %>')"
                                 title="Bookmark">
                                <i class='<%# Convert.ToInt32(Eval("IsBookmarked")) == 1
                                    ? "bi bi-bookmark-fill"
                                    : "bi bi-bookmark" %>'></i>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

      
        <asp:Panel ID="pnlEmptyFeed" runat="server" Visible="false">
            <div class="empty-feed">
                <i class="bi bi-twitter-x" style="font-size:40px;"></i>
                <p class="mt-3">No posts yet. Be the first to post!</p>
            </div>
        </asp:Panel>

    </div>

</div>

<div class="tweet-modal-overlay" id="tweetModalOverlay" onclick="handleOverlayClick(event)">
    <div class="tweet-modal" id="tweetModalBox">

        <div class="modal-top-bar">
            <button class="modal-close-btn" onclick="closeTweetModal()">
                <i class="bi bi-x-lg"></i>
            </button>
            <button class="modal-drafts">Drafts</button>
        </div>


        <div class="modal-body">
            <div class="user-avatar" style="width:44px;height:44px;font-size:20px;flex-shrink:0;">
                <i class="bi bi-person-fill"></i>
            </div>
            <asp:TextBox
                ID="txtModalTweet"
                runat="server"
                TextMode="MultiLine"
                CssClass="modal-textarea"
                placeholder="What's happening?"
                MaxLength="280"
                ClientIDMode="Static" />
        </div>

        <div class="modal-reply-note">
            <i class="bi bi-globe2"></i> Everyone can reply
        </div>

        <hr class="modal-divider" />

        <asp:FileUpload ID="fileUploadModal" runat="server" ClientIDMode="Static" accept="image/*" style="display:none;" />
        <div id="modalImagePreviewWrap" style="display:none; margin:8px 0; position:relative; max-width:260px;">
            <img id="modalImagePreview" src="" style="max-width:100%; border-radius:16px; display:block; border:1px solid #2f3336;" />
            <button type="button" onclick="clearModalImage(); return false;"
                style="position:absolute; top:6px; right:6px; background:rgba(0,0,0,0.75); color:#fff; border:none; border-radius:50%; width:26px; height:26px; cursor:pointer;">&times;</button>
        </div>

        <div class="modal-actions">
            <div class="modal-icons">
                <button type="button" class="composer-icon-btn" title="Media" onclick="document.getElementById('fileUploadModal').click(); return false;">
                    <i class="bi bi-image"></i>
                </button>
            </div>

            <asp:Button
                ID="btnModalPost"
                runat="server"
                Text="Post"
                CssClass="btn-post"
                OnClick="btnPost_Click"
                OnClientClick="copyModalToMain()" />
        </div>

    </div>
</div>

    <!-- Hidden field to store TweetId for reporting -->
    <asp:HiddenField ID="hdnReportTweetId" runat="server" ClientIDMode="Static" />

    <asp:Button ID="btnViewComments" runat="server" Style="display:none;" OnClick="btnViewComments_Click" />

    <!-- Report Modal -->
    <div class="report-modal-overlay" id="reportModalOverlay" onclick="handleReportOverlayClick(event)">
        <div class="report-modal">
            <div class="modal-top-bar">
                <strong style="font-size:17px;">Report Tweet</strong>
                <button class="modal-close-btn" onclick="closeReportModal(); return false;">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <p style="color:#71767b; font-size:14px; margin-bottom:14px;">Why are you reporting this tweet?</p>

            <button class="report-option" onclick="submitReport('Spam'); return false;">🚫 Spam</button>
            <button class="report-option" onclick="submitReport('Hate Speech'); return false;">🤬 Hate Speech</button>
            <button class="report-option" onclick="submitReport('Misinformation'); return false;">❌ Misinformation</button>
            <button class="report-option" onclick="submitReport('Harassment'); return false;">⚠️ Harassment</button>
            <button class="report-option" onclick="submitReport('Inappropriate Content'); return false;">🔞 Inappropriate Content</button>

            <!-- Hidden button triggered by JS -->
            <asp:HiddenField ID="hdnReportReason" runat="server" ClientIDMode="Static" />
            <asp:Button ID="btnSubmitReport" runat="server" Text="Submit"
                Style="display:none;"
                OnClick="btnSubmitReport_Click" />
        </div>
    </div>
        <asp:HiddenField ID="hdnCommentTweetId" runat="server" ClientIDMode="Static" />

    <asp:HiddenField
    ID="HiddenField1"
    runat="server"
    ClientIDMode="Static" />

<div class="comment-modal-overlay" id="commentModalOverlay">

    <div class="comment-modal">

        <!-- Header -->
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">

            <h5 style="color:#fff; margin:0;">
                Replies
            </h5>

            <button
                type="button"
                onclick="closeCommentModal(); return false;"
                style="
                    background:none;
                    border:none;
                    color:#fff;
                    font-size:22px;
                    cursor:pointer;
                ">
                &times;
            </button>

        </div>


        <!-- Existing comments -->
        <div class="comments-list">

            <asp:Repeater
                ID="rptComments"
                runat="server">

                <ItemTemplate>

                    <div class="comment-item"
                         style="
                            padding:10px 0;
                            border-bottom:1px solid #2f3336;
                         ">

                        <div style="display:flex; gap:8px;">

                            <strong style="color:#fff;">
                                @<%# Eval("Username") %>
                            </strong>

                        </div>

                        <div style="
                            color:#e7e9ea;
                            margin-top:4px;
                            word-break:break-word;
                        ">

                            <%# Eval("CommentText") %>

                        </div>

                        <div style="
                            color:#71767b;
                            font-size:12px;
                            margin-top:4px;
                        ">

                            <%# GetTimeAgo((DateTime)Eval("CreatedAt")) %>

                        </div>

                    </div>

                </ItemTemplate>

            </asp:Repeater>

            <asp:Panel
                ID="pnlNoComments"
                runat="server"
                Visible="false">

                <div style="
                    color:#71767b;
                    text-align:center;
                    padding:20px 0;
                ">

                    No replies yet. Be the first to reply!

                </div>

            </asp:Panel>

        </div>


        <!-- New comment -->
        <div style="
            margin-top:15px;
            border-top:1px solid #2f3336;
            padding-top:15px;
        ">

            <asp:TextBox
                ID="txtComment"
                runat="server"
                TextMode="MultiLine"
                CssClass="modal-textarea"
                placeholder="Write your reply..."
                MaxLength="200"
                Rows="3"
                ClientIDMode="Static" />

            <div style="
                margin-top:12px;
                display:flex;
                gap:8px;
                justify-content:flex-end;
            ">

                <button
                    type="button"
                    onclick="closeCommentModal(); return false;"
                    style="
                        background:none;
                        border:1px solid #536471;
                        color:#fff;
                        padding:8px 16px;
                        border-radius:20px;
                        cursor:pointer;
                    ">
                    Cancel
                </button>

                <asp:Button
                    ID="btnSubmitComment"
                    runat="server"
                    Text="Reply"
                    CssClass="btn-post"
                    OnClick="btnSubmitComment_Click" />

            </div>

        </div>

    </div>

</div>

    <asp:HiddenField ID="hdnLikeTweetId" runat="server" ClientIDMode="Static" />
    <asp:Button ID="btnSubmitLike" runat="server" Style="display:none;" OnClick="btnSubmitLike_Click" />

    <asp:HiddenField ID="hdnRepostTweetId" runat="server" ClientIDMode="Static" />
    <asp:Button ID="btnSubmitRepost" runat="server" Style="display:none;" OnClick="btnSubmitRepost_Click" />

    <asp:HiddenField ID="hdnBookmarkTweetId"
    runat="server" ClientIDMode="Static" />

    <asp:Button ID="btnSubmitBookmark"
        runat="server"
        Style="display:none;"
        OnClick="btnSubmitBookmark_Click" />
</form>

<script>
    function openTweetModal() {
        document.getElementById('tweetModalOverlay').classList.add('show');
        setTimeout(function () {
            document.getElementById('txtModalTweet').focus();
        }, 100);
    }

    function closeTweetModal() {
        document.getElementById('tweetModalOverlay').classList.remove('show');
    }

    // Close when clicking outside the modal box
    function handleOverlayClick(e) {
        if (e.target === document.getElementById('tweetModalOverlay')) {
            closeTweetModal();
        }
    }

    // Close on Escape key
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeTweetModal();
    });

    // Copy modal textarea value (and any selected image) into the hidden main controls before postback
    function copyModalToMain() {
        var modalText = document.getElementById('txtModalTweet');
        var mainText = document.getElementById('txtTweet');
        if (modalText && mainText) {
            mainText.value = modalText.value;
        }

        var modalFile = document.getElementById('fileUploadModal');
        var mainFile = document.getElementById('fileUpload');
        if (modalFile && mainFile && modalFile.files && modalFile.files.length > 0) {
            var dt = new DataTransfer();
            dt.items.add(modalFile.files[0]);
            mainFile.files = dt.files;
        }
    }

    function previewImage(inputId, imgId, wrapId) {
        var input = document.getElementById(inputId);
        var img = document.getElementById(imgId);
        var wrap = document.getElementById(wrapId);
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                img.src = e.target.result;
                wrap.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            wrap.style.display = 'none';
        }
    }

    function clearInlineImage() {
        document.getElementById('fileUpload').value = '';
        document.getElementById('inlineImagePreviewWrap').style.display = 'none';
    }

    function clearModalImage() {
        document.getElementById('fileUploadModal').value = '';
        document.getElementById('modalImagePreviewWrap').style.display = 'none';
    }

    document.getElementById('fileUpload').addEventListener('change', function () {
        previewImage('fileUpload', 'inlineImagePreview', 'inlineImagePreviewWrap');
    });
    document.getElementById('fileUploadModal').addEventListener('change', function () {
        previewImage('fileUploadModal', 'modalImagePreview', 'modalImagePreviewWrap');
    });

    // Enable / disable inline Post button based on textarea
    var inlineTextarea = document.getElementById('txtTweet');
    var inlinePostBtn = document.querySelector('.composer-actions .btn-post');

    if (inlineTextarea && inlinePostBtn) {
        inlineTextarea.addEventListener('input', function () {

            inlinePostBtn.disabled = this.value.trim().length === 0;

            var message = document.getElementById('messageContainer');

            if (message && this.value.trim().length > 0) {
                message.style.display = 'none';
            }
        });

        inlinePostBtn.disabled =
            inlineTextarea.value.trim().length === 0;
    }

    // Enable / disable modal Post button
    var modalTextarea = document.getElementById('txtModalTweet');
    var modalPostBtn = document.querySelector('#tweetModalBox .btn-post');

    if (modalTextarea && modalPostBtn) {
        modalTextarea.addEventListener('input', function () {

            modalPostBtn.disabled =
                this.value.trim().length === 0;

            var message = document.getElementById('messageContainer');

            if (message && this.value.trim().length > 0) {
                message.style.display = 'none';
            }
        });

        modalPostBtn.disabled = true;
    }

    function openReportModal(tweetId) {
        document.getElementById('hdnReportTweetId').value = tweetId;
        document.getElementById('reportModalOverlay').classList.add('show');
    }
    function closeReportModal() {
        document.getElementById('reportModalOverlay').classList.remove('show');
    }

    function closeAlertMessage(event) {

        if (event) {
            event.preventDefault();
            event.stopPropagation();
        }

        var message = document.getElementById('messageContainer');

        if (message) {
            message.style.display = 'none';
        }

        return false;
    }

    function viewComments(tweetId) {
        document.getElementById('hdnCommentTweetId').value = tweetId;
        document.getElementById('btnViewComments').click();
        return false;
    }

    function handleReportOverlayClick(e) {
        if (e.target === document.getElementById('reportModalOverlay')) {
            closeReportModal();
        }
    }
    function submitReport(reason) {
        document.getElementById('hdnReportReason').value = reason;
        document.getElementById('btnSubmitReport').click();
    }

    function postComment(tweetId) {
        var text = prompt("Write your reply:");
        if (text && text.trim() !== "") {
            document.getElementById('hdnCommentTweetId').value = tweetId;
            document.getElementById('hdnCommentText').value = text;
            document.getElementById('btnSubmitComment').click();
        }
    }

    function openCommentModal(tweetId) {
        document.getElementById('hdnCommentTweetId').value = tweetId;
        document.getElementById('commentModalOverlay').classList.add('show');
        document.getElementById('txtComment').focus();
    }
    function closeCommentModal() {
        document.getElementById('commentModalOverlay').classList.remove('show');
    }

    function submitLike(tweetId) {
        document.getElementById('hdnLikeTweetId').value = tweetId;
        document.getElementById('btnSubmitLike').click();
    }

    function submitRepost(tweetId) {
        document.getElementById('hdnRepostTweetId').value = tweetId;
        document.getElementById('btnSubmitRepost').click();
    }

    function submitBookmark(tweetId) {
        document.getElementById('hdnBookmarkTweetId').value = tweetId;
        document.getElementById('btnSubmitBookmark').click();
    }

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
