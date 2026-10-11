<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Follow.aspx.cs" Inherits="EliteTweet.FollowPage" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Follow / EliteTweet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; background: #000; color: #e7e9ea; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
        .page-wrapper { display: flex; width: 100%; max-width: 1280px; margin: 0 auto; align-items: flex-start; }
        .left-sidebar { width: 275px; min-height: 100vh; padding: 8px 12px; position: sticky; top: 0; height: 100vh; display: flex; flex-direction: column; overflow-y: auto; flex-shrink: 0; }
        .x-logo { font-size: 28px; padding: 10px 14px; border-radius: 50%; display: inline-block; margin-bottom: 4px; }
        .x-logo:hover, .nav-item:hover, .user-profile-bottom:hover { background: #1a1a1a; }
        .nav-item { display: flex; align-items: center; gap: 18px; padding: 12px 14px; border-radius: 30px; font-size: 19px; color: #e7e9ea; text-decoration: none; white-space: nowrap; }
        .nav-item.active { font-weight: 700; }
        .nav-item i { font-size: 22px; min-width: 26px; }
        .btn-post-sidebar { background: #1d9bf0; color: #fff; border: none; border-radius: 30px; font-size: 17px; font-weight: 700; padding: 14px; width: 100%; margin-top: 16px; }
        .user-profile-bottom { display: flex; align-items: center; gap: 12px; padding: 10px 14px; border-radius: 30px; margin-top: auto; margin-bottom: 8px; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background: #536471; display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0; overflow: hidden; }
        .user-avatar img { width: 100%; height: 100%; object-fit: cover; }
        .user-info-name { font-weight: 700; font-size: 15px; line-height: 1.3; }
        .user-info-handle, .handle { color: #71767b; font-size: 14px; }
        .main-content { flex: 1; min-width: 0; min-height: 100vh; border-left: 1px solid #2f3336; border-right: 1px solid #2f3336; }
        .page-header { position: sticky; top: 0; background: rgba(0,0,0,.85); backdrop-filter: blur(12px); z-index: 10; border-bottom: 1px solid #2f3336; }
        .header-top { display: flex; align-items: center; gap: 28px; padding: 14px 16px 10px; }
        .back-link { color: #e7e9ea; font-size: 20px; text-decoration: none; }
        .page-title { font-size: 20px; font-weight: 800; margin: 0; }
        .profile-handle { color: #71767b; font-size: 13px; margin-left: 64px; margin-top: -10px; padding-bottom: 10px; }
        .tabs { display: flex; border-bottom: 1px solid #2f3336; }
        .tab { flex: 1; display: block; padding: 17px 8px; text-align: center; color: #71767b; text-decoration: none; font-weight: 600; position: relative; }
        .tab:hover { background: #111; color: #e7e9ea; }
        .tab.active { color: #e7e9ea; }
        .tab.active:after { content: ""; position: absolute; height: 4px; width: 90%; max-width: 250px; background: #1d9bf0; border-radius: 4px; bottom: 0; left: 27%; }
        .list-heading { font-size: 20px; font-weight: 800; padding: 22px 16px 8px; }
        .user-row { display: flex; align-items: flex-start; gap: 12px; padding: 16px; border-bottom: 1px solid #2f3336; transition: background .2s; }
        .user-row:hover { background: #080808; }
        .person-avatar { width: 48px; height: 48px; flex-shrink: 0; border-radius: 50%; overflow: hidden; background: #536471; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .person-avatar img { width: 100%; height: 100%; object-fit: cover; }
        .person-info { flex: 1; min-width: 0; }
        .person-name { color: #e7e9ea; font-weight: 700; font-size: 15px; overflow-wrap: anywhere; }
        .person-handle { color: #71767b; font-size: 14px; }
        .person-actions { margin-left: auto; }
        .outline-btn { display: inline-block; border: 1px solid #536471; color: #e7e9ea; border-radius: 22px; padding: 7px 15px; background: transparent; text-decoration: none; font-weight: 700; font-size: 14px; white-space: nowrap; }
        .outline-btn:hover { background: rgba(255,255,255,.08); color: #e7e9ea; }
        .empty-state { padding: 58px 28px; max-width: 470px; margin: 0 auto; }
        .empty-state h2 { font-size: 28px; line-height: 1.25; font-weight: 800; color: #e7e9ea; }
        .empty-state p { color: #71767b; margin-top: 12px; }
        ::-webkit-scrollbar { width: 0; }
        @media (max-width: 1050px) {.page-wrapper { max-width: 900px; } }
        @media (max-width: 700px) { .left-sidebar { width: 72px; padding: 8px 5px; } .nav-item { justify-content: center; padding: 12px 8px; font-size: 0; gap: 0; } .nav-item i { font-size: 22px; } .x-logo { padding: 10px; } .btn-post-sidebar { font-size: 0; padding: 12px 4px; } .btn-post-sidebar:after { content: "+"; font-size: 22px; } .user-profile-bottom { justify-content: center; padding: 8px 0; } .user-profile-bottom .flex-grow-1, .user-profile-bottom > .user-info { display: none; } .main-content { width: calc(100% - 72px); } .empty-state h2 { font-size: 23px; } }
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="page-wrapper">
    <aside class="left-sidebar">
        <div class="x-logo"><i class="bi bi-twitter-x"></i></div>
        <a class="nav-item" href="HomePage.aspx"><i class="bi bi-house-fill"></i>Home</a>
        <a class="nav-item" href="Explore.aspx"><i class="bi bi-search"></i>Explore</a>
        <a class="nav-item" href="Notifications.aspx"><i class="bi bi-bell"></i>Notifications</a>
        <a class="nav-item active" href="Follow.aspx?tab=following"><i class="bi bi-people-fill"></i>Follow</a>
        <a class="nav-item" href="Bookmarks.aspx"><i class="bi bi-bookmark"></i>Bookmarks</a>
        <a class="nav-item" href="ProfilePage.aspx"><i class="bi bi-person"></i>Profile</a>
        <a class="nav-item" href="FirstPage.aspx"><i class="bi bi-box-arrow-right"></i>Log out</a>
        <button class="btn-post-sidebar" onclick="window.location.href='HomePage.aspx'; return false;">Post</button>
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
    </aside>

    <main class="main-content">
        <div class="page-header">
            <div class="header-top">
                <a class="back-link" href="HomePage.aspx"><i class="bi bi-arrow-left"></i></a>
                <h1 class="page-title"><asp:Label ID="lblPageTitle" runat="server" Text="Hema" /></h1>
            </div>
            <div class="profile-handle"><asp:Label ID="lblCurrentHandle" runat="server" /></div>
            <div class="tabs">
                <a id="tabFollowing" runat="server" class="tab" href="Follow.aspx?tab=following">Following <asp:Label ID="lblFollowingCount" runat="server" Text="0" /></a>
                <a id="tabFollowers" runat="server" class="tab" href="Follow.aspx?tab=followers">Followers <asp:Label ID="lblFollowersCount" runat="server" Text="0" /></a>
            </div>
        </div>

        <asp:Panel ID="pnlListHeading" runat="server" CssClass="list-heading">
            <asp:Label ID="lblListHeading" runat="server" Text="Following" />
        </asp:Panel>

        <asp:Repeater ID="rptPeople" runat="server">
            <ItemTemplate>
                <div class="user-row">
                    <div class="person-avatar">
                        <asp:Image ID="imgPerson" runat="server" ImageUrl='<%# ResolveUrl("~/" + Eval("ProfilePicture").ToString()) %>' Visible='<%# !String.IsNullOrEmpty(Eval("ProfilePicture").ToString()) %>' AlternateText="Profile picture" />
                        <asp:Panel ID="pnlDefaultAvatar" runat="server" Visible='<%# String.IsNullOrEmpty(Eval("ProfilePicture").ToString()) %>'><i class="bi bi-person-fill"></i></asp:Panel>
                    </div>
                    <div class="person-info">
                        <div class="person-name"><%#: Eval("Name") %></div>
                        <div class="person-handle">@<%#: Eval("Username") %></div>
                    </div>
                    <div class="person-actions">
                        <a class="outline-btn" href='<%# "ProfilePage.aspx?username=" + Server.UrlEncode(Eval("Username").ToString()) %>'>View profile</a>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
            <h2><asp:Label ID="lblEmptyTitle" runat="server" Text="Nothing to show yet" /></h2>
            <p><asp:Label ID="lblEmptyMessage" runat="server" Text="When you follow people, they'll appear here." /></p>
        </asp:Panel>
    </main>
</div>
</form>
</body>
</html>
