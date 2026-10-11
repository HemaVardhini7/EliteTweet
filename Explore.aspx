<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Explore.aspx.cs" Inherits="EliteTweet.Explore" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Explore / EliteTweet</title>
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
            padding: 14px 16px;
            border-bottom: 1px solid #2f3336;
        }

        .page-header h2 {
            font-size: 20px;
            font-weight: 800;
            margin: 0 0 12px 0;
        }

        /* ─── SEARCH BAR ─── */
        .search-wrap {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .search-input-wrap {
            position: relative;
            flex: 1;
        }

        .search-input-wrap .bi-search {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #71767b;
            font-size: 16px;
            pointer-events: none;
        }

        .search-input {
            width: 100%;
            background: #202327;
            color: #e7e9ea;
            border: 1px solid transparent;
            border-radius: 30px;
            padding: 11px 16px 11px 42px;
            font-size: 15px;
            outline: none;
            transition: border-color 0.2s, background 0.2s;
        }
        .search-input:focus {
            background: #000;
            border-color: #1d9bf0;
        }
        .search-input::placeholder { color: #71767b; }

        .search-btn {
            background: #1d9bf0;
            color: #fff;
            border: none;
            border-radius: 30px;
            padding: 10px 22px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
            white-space: nowrap;
        }
        .search-btn:hover { background: #1a8cd8; }

        /* ─── USER CARD ─── */
        .user-card {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid #2f3336;
            transition: background 0.2s;
        }
        .user-card:hover { background: #080808; }

        .user-card-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #536471;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: #fff;
            flex-shrink: 0;
        }

        .user-card-info { flex: 1; min-width: 0; }

        .user-card-name {
            font-weight: 700;
            font-size: 15px;
            color: #e7e9ea;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .user-card-handle {
            color: #71767b;
            font-size: 14px;
            margin-top: 2px;
        }

        .user-card-actions {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-shrink: 0;
        }

        .btn-view-profile {
            background: transparent;
            color: #e7e9ea;
            border: 1px solid #536471;
            border-radius: 20px;
            padding: 7px 14px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
            transition: background 0.2s;
            cursor: pointer;
        }
        .btn-view-profile:hover { background: rgba(255,255,255,0.08); color: #e7e9ea; }

        .follow-btn {
            background: #fff;
            color: #000;
            border: none;
            border-radius: 20px;
            padding: 7px 16px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            white-space: nowrap;
            transition: background 0.2s;
        }
        .follow-btn:hover { background: #e7e9ea; color: #000; }
        .follow-btn.following {
            background: transparent;
            color: #e7e9ea;
            border: 1px solid #536471;
        }
        .follow-btn.following:hover { background: rgba(255,255,255,0.08); }

        /* ─── EMPTY STATE ─── */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #71767b;
        }
        .empty-state i { font-size: 44px; margin-bottom: 12px; display: block; }
        .empty-state p { font-size: 15px; margin: 0; }

                .user-avatar img,
        .user-card-avatar img {
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
        <a class="nav-item active" href="Explore.aspx">
            <i class="bi bi-search"></i> Explore
        </a>
        <a class="nav-item" href="Notifications.aspx">
            <i class="bi bi-bell"></i> Notifications
        </a>
        <a class="nav-item" href="Follow.aspx?tab=following">
            <i class="bi bi-people"></i> Follow
        </a>
        <a class="nav-item" href="Bookmarks.aspx">
            <i class="bi bi-bookmark"></i> Bookmarks
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
                <div class="user-info-name"><asp:Label ID="lblSidebarName" runat="server" Text="User" /></div>
                <div class="user-info-handle"><asp:Label ID="lblSidebarHandle" runat="server" Text="@username" /></div>
            </div>
        </div>

    </div>

    <!-- ═══════════ MAIN CONTENT ═══════════ -->
    <div class="main-content">

        <div class="page-header">
            <h2>Explore</h2>

            <div class="search-wrap">
                <div class="search-input-wrap">
                    <i class="bi bi-search"></i>
                    <asp:TextBox ID="txtSearch" runat="server"
                        CssClass="search-input"
                        placeholder="Search by name, username or user ID" />
                </div>

                <asp:Button ID="btnSearch" runat="server"
                    Text="Search"
                    CssClass="search-btn"
                    OnClick="btnSearch_Click" />
            </div>
        </div>

        <!-- Results -->
        <asp:Repeater ID="rptUsers" runat="server"
            OnItemCommand="rptUsers_ItemCommand"
            OnItemDataBound="rptUsers_ItemDataBound">
            <ItemTemplate>
                <div class="user-card">

                    <div class="user-card-avatar">
                        <asp:Image ID="imgUserProfile" runat="server"
                            AlternateText="Profile picture"
                            Visible="false" />

                        <asp:Panel ID="pnlDefaultUserAvatar" runat="server">
                            <i class="bi bi-person-fill"></i>
                        </asp:Panel>
                    </div>

                    <div class="user-card-info">
                        <div class="user-card-name"><%#: Eval("Name") %></div>
                        <div class="user-card-handle">@<%#: Eval("Username") %></div>
                    </div>

                    <div class="user-card-actions">
                        <a class="btn-view-profile"
                            href='<%# "ProfilePage.aspx?username=" + Server.UrlEncode(Eval("Username").ToString()) %>'>
                            View profile
                        </a>
                        <asp:LinkButton ID="btnFollow" runat="server"
                            CssClass="follow-btn"
                            CommandName="ToggleFollow"
                            CommandArgument='<%# Eval("UserId") %>'>
                            Follow
                        </asp:LinkButton>
                    </div>

                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state">
                <i class="bi bi-search"></i>
                <p>No users found. Try a different search.</p>
            </div>
        </asp:Panel>

    </div>

</div>
</form>
</body>
</html>