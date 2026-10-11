<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Bookmarks.aspx.cs"
    Inherits="EliteTweet.Bookmarks" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bookmarks / EliteTweet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        * { box-sizing: border-box; }

        body {
            background-color: #000;
            color: #e7e9ea;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            margin: 0;
        }

        /* ─── PAGE WRAPPER ─── */
        .page-wrapper {
            display: flex;
            width: 100%;
            max-width: 1280px;
            margin: 0 auto;
            align-items: flex-start;
        }

        /* ─── LEFT SIDEBAR ─── */
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
            color: #e7e9ea;
            text-decoration: none;
            transition: background 0.2s;
            white-space: nowrap;
        }
        .nav-item:hover { background: #1a1a1a; color: #e7e9ea; }
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
        .user-info-name  { font-weight: 700; font-size: 15px; line-height: 1.3; }
        .user-info-handle { color: #71767b; font-size: 14px; }

        /* ─── MAIN COLUMN ─── */
        .main-content {
            flex: 1;
            min-width: 0;
            min-height: 100vh;
            border-left: 1px solid #2f3336;
            border-right: 1px solid #2f3336;
        }

        /* ─── STICKY HEADER ─── */
        .page-header {
            position: sticky;
            top: 0;
            background: rgba(0,0,0,0.85);
            backdrop-filter: blur(12px);
            z-index: 10;
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 12px 16px;
            border-bottom: 1px solid #2f3336;
        }

        .back-btn {
            background: none;
            border: none;
            color: #e7e9ea;
            font-size: 20px;
            cursor: pointer;
            padding: 6px 8px;
            border-radius: 50%;
            transition: background 0.2s;
            line-height: 1;
        }
        .back-btn:hover { background: #1a1a1a; }

        .page-header-info { line-height: 1.3; }
        .page-header-title { font-size: 20px; font-weight: 800; }
        .page-header-sub   { font-size: 13px; color: #71767b; }

        /* ─── TWEET CARD ─── */
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
            overflow: hidden;
        }

        .tweet-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .tweet-body { flex: 1; min-width: 0; }

        .tweet-meta {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 4px;
            flex-wrap: wrap;
        }

        .tweet-name {
            font-weight: 700;
            font-size: 15px;
            color: #e7e9ea;
        }

        .tweet-handle, .tweet-dot, .tweet-time {
            color: #71767b;
            font-size: 14px;
        }

        .tweet-text {
            font-size: 15px;
            line-height: 1.5;
            color: #e7e9ea;
            margin-bottom: 10px;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
        }

        .tweet-image {
            width: 100%;
            max-height: 400px;
            object-fit: contain;
            border-radius: 16px;
            border: 1px solid #2f3336;
            margin-bottom: 10px;
            display: block;
        }

        .tweet-actions {
            display: flex;
            align-items: center;
            gap: 24px;
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

        .btn-remove-bookmark {
            background: none;
            border: none;
            color: #1d9bf0;
            font-size: 16px;
            padding: 4px 6px;
            border-radius: 20px;
            cursor: pointer;
            margin-left: auto;
            transition: color 0.2s, background 0.2s;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .btn-remove-bookmark:hover {
            color: #f4212e;
            background: rgba(244,33,46,0.1);
        }

        /* ─── EMPTY STATE ─── */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #71767b;
        }
        .empty-state i { font-size: 52px; display: block; margin-bottom: 16px; }
        .empty-state h3 { font-size: 24px; font-weight: 800; color: #e7e9ea; margin-bottom: 8px; }
        .empty-state p  { font-size: 15px; margin: 0; }

        .user-avatar {
            overflow: hidden;
        }

        .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        /* ─── SCROLLBAR HIDE ─── */
        ::-webkit-scrollbar { width: 0; }
    </style>
</head>

<body>
<form id="form1" runat="server">
<div class="page-wrapper">

    <!-- ═══════════ LEFT SIDEBAR ═══════════ -->
    <div class="left-sidebar">

        <div class="x-logo">
            <i class="bi bi-twitter-x"></i>
        </div>

        <a class="nav-item" href="HomePage.aspx">
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
        <a class="nav-item active" href="Bookmarks.aspx">
            <i class="bi bi-bookmark-fill"></i> Bookmarks
        </a>
        <a class="nav-item" href="ProfilePage.aspx">
            <i class="bi bi-person"></i> Profile
        </a>
        <a class="nav-item" href="FirstPage.aspx">
            <i class="bi bi-box-arrow-right"></i> Log out
        </a>

        <button class="btn-post-sidebar" onclick="window.location.href='HomePage.aspx'; return false;">
            Post
        </button>

        <div class="user-profile-bottom">
            <div class="user-avatar">
                <asp:Image ID="imgSidebarProfile" runat="server"
                    AlternateText="Profile picture"
                    Visible="false" />

                <asp:Panel ID="pnlSidebarDefaultAvatar" runat="server">
                    <i class="bi bi-person-fill"></i>
                </asp:Panel>
            </div>

            <div class="flex-grow-1">
                <div class="user-info-name">
                    <asp:Label ID="lblSidebarName" runat="server" Text="User" />
                </div>
                <div class="user-info-handle">
                    <asp:Label ID="lblSidebarHandle" runat="server" Text="@username" />
                </div>
            </div>
        </div>

    </div>

    <!-- ═══════════ MAIN CONTENT ═══════════ -->
    <div class="main-content">

        <div class="page-header">
            <button class="back-btn" onclick="history.back(); return false;">
                <i class="bi bi-arrow-left"></i>
            </button>
            <div class="page-header-info">
                <div class="page-header-title">Bookmarks</div>
                <asp:Label ID="lblUsername" runat="server"
                    CssClass="page-header-sub" />
            </div>
        </div>

        <!-- Bookmarked tweets -->
        <asp:Repeater ID="rptBookmarks" runat="server"
            OnItemCommand="rptBookmarks_ItemCommand"
            OnItemDataBound="rptBookmarks_ItemDataBound">
            <ItemTemplate>
                <div class="tweet-card">

            <div class="tweet-avatar">
                <asp:Image ID="imgTweetProfile" runat="server"
                    AlternateText="Profile picture"
                    Visible="false" />

                <asp:Panel ID="pnlDefaultTweetAvatar" runat="server">
                    <i class="bi bi-person-fill"></i>
                </asp:Panel>
            </div>

                    <div class="tweet-body">
                        <div class="tweet-meta">
                            <span class="tweet-name"><%#: Eval("Name") %></span>
                            <span class="tweet-handle">@<%#: Eval("Username") %></span>
                            <span class="tweet-dot">&middot;</span>
                            <span class="tweet-time"><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></span>
                        </div>

                        <div class="tweet-text"><%#: Eval("TweetText") %></div>

                        <asp:Image runat="server"
                            CssClass="tweet-image"
                            ImageUrl='<%# Eval("ImagePath") %>'
                            Visible='<%# Eval("ImagePath") != DBNull.Value
                                && !string.IsNullOrWhiteSpace(Eval("ImagePath").ToString()) %>' />

                        <div class="tweet-actions">
                            <div class="tweet-action">
                                <i class="bi bi-heart"></i>
                                <span><%# Eval("LikeCount") %></span>
                            </div>

                            <div class="tweet-action">
                                <i class="bi bi-chat"></i>
                                <span><%# Eval("CommentCount") %></span>
                            </div>

                            <asp:LinkButton ID="btnRemove"
                                runat="server"
                                CssClass="btn-remove-bookmark"
                                CommandName="RemoveBookmark"
                                CommandArgument='<%# Eval("TweetId") %>'
                                ToolTip="Remove bookmark">
                                <i class="bi bi-bookmark-fill"></i>
                            </asp:LinkButton>
                        </div>
                    </div>

                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state">
                <i class="bi bi-bookmark"></i>
                <h3>Save posts for later</h3>
                <p>Don't let the good ones get away. Bookmark posts to easily find them again in the future.</p>
            </div>
        </asp:Panel>

    </div>

</div>
</form>
</body>
</html>