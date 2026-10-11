<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Notifications.aspx.cs"
    Inherits="EliteTweet.Notifications" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Notifications / EliteTweet</title>
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
            margin: 0;
        }

        /* ─── SECTION TITLE ─── */
        .section-title {
            padding: 14px 16px;
            font-size: 15px;
            font-weight: 700;
            color: #71767b;
            border-bottom: 1px solid #2f3336;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        /* ─── NOTIFICATION CARD ─── */
        .notif-card {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 16px;
            border-bottom: 1px solid #2f3336;
            transition: background 0.2s;
            cursor: pointer;
        }
        .notif-card:hover { background: #080808; }

        .notif-icon {
            font-size: 24px;
            flex-shrink: 0;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .notif-icon.heart   { color: #f91880; background: rgba(249,24,128,0.08); }
        .notif-icon.comment { color: #1d9bf0; background: rgba(29,155,240,0.08); }
        .notif-icon.follow  { color: #00ba7c; background: rgba(0,186,124,0.08); }

        .notif-body { flex: 1; min-width: 0; }

        .notif-actor {
            font-size: 15px;
            font-weight: 700;
            color: #e7e9ea;
        }

        .notif-action {
            font-size: 15px;
            color: #e7e9ea;
            margin-bottom: 4px;
        }

        .notif-handle {
            color: #71767b;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .notif-preview {
            color: #71767b;
            font-size: 14px;
            overflow-wrap: anywhere;
            border-left: 2px solid #2f3336;
            padding-left: 10px;
            margin-top: 6px;
        }

        .notif-time {
            color: #71767b;
            font-size: 12px;
            margin-top: 4px;
        }

        /* ─── ACCEPT / REJECT BUTTONS ─── */
        .notif-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .btn-accept {
            background: #1d9bf0;
            color: #fff;
            border: none;
            border-radius: 20px;
            padding: 8px 18px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
            text-decoration: none;
        }
        .btn-accept:hover { background: #1a8cd8; color: #fff; }

        .btn-reject {
            background: transparent;
            color: #e7e9ea;
            border: 1px solid #536471;
            border-radius: 20px;
            padding: 8px 18px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
            text-decoration: none;
        }
        .btn-reject:hover { background: rgba(255,255,255,0.08); color: #e7e9ea; }

        /* ─── EMPTY STATE ─── */
        .empty-state {
            padding: 40px 16px;
            color: #71767b;
            font-size: 15px;
            text-align: center;
        }
        .empty-state i { font-size: 40px; display: block; margin-bottom: 10px; }

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
        <a class="nav-item active" href="Notifications.aspx">
            <i class="bi bi-bell-fill"></i> Notifications
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
                <i class="bi bi-person-fill"></i>
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
            <h2>Notifications</h2>
        </div>

        <!-- ── FOLLOW REQUESTS ── -->
        <div class="section-title">Follow Requests</div>

        <asp:Repeater ID="rptRequests" runat="server"
            OnItemCommand="rptRequests_ItemCommand">
            <ItemTemplate>
                <div class="notif-card">

                    <div class="notif-icon follow">
                        <i class="bi bi-person-plus-fill"></i>
                    </div>

                    <div class="notif-body">
                        <div class="notif-action">
                            <span class="notif-actor"><%#: Eval("Name") %></span>
                            wants to follow you
                        </div>
                        <div class="notif-handle">@<%#: Eval("Username") %></div>

                        <div class="notif-actions">
                            <asp:LinkButton ID="btnAccept" runat="server"
                                CssClass="btn-accept"
                                CommandName="AcceptRequest"
                                CommandArgument='<%# Eval("FollowerId") %>'>
                                Accept
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnReject" runat="server"
                                CssClass="btn-reject"
                                CommandName="RejectRequest"
                                CommandArgument='<%# Eval("FollowerId") %>'>
                                Reject
                            </asp:LinkButton>
                        </div>
                    </div>

                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoRequests" runat="server" Visible="false">
            <div class="empty-state">
                <i class="bi bi-person-check"></i>
                No pending follow requests.
            </div>
        </asp:Panel>

        <!-- ── ACTIVITY ── -->
        <div class="section-title">Activity</div>

        <asp:Repeater ID="rptActivity" runat="server">
            <ItemTemplate>
                <div class="notif-card">

                    <div class='notif-icon <%# Eval("Type").ToString() == "Like" ? "heart" : "comment" %>'>
                        <i class='<%# Eval("Type").ToString() == "Like"
                            ? "bi bi-heart-fill"
                            : "bi bi-chat-fill" %>'></i>
                    </div>

                    <div class="notif-body">
                        <div class="notif-action">
                            <span class="notif-actor"><%#: Eval("Name") %></span>
                            <%# Eval("Type").ToString() == "Like"
                                ? " liked your post"
                                : " replied to your post" %>
                        </div>
                        <div class="notif-handle">@<%#: Eval("Username") %></div>

                        <div class="notif-preview">
                            <%#: Eval("Preview") %>
                        </div>

                        <div class="notif-time">
                            <%# GetTimeAgo(Convert.ToDateTime(Eval("CreatedAt"))) %>
                        </div>
                    </div>

                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoActivity" runat="server" Visible="false">
            <div class="empty-state">
                <i class="bi bi-bell"></i>
                No likes or replies yet.
            </div>
        </asp:Panel>

    </div>

</div>
</form>
</body>
</html>