<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="EliteTweet.AdminDashboard" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard – EliteTweet</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <style>
       * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    background: #000;
    color: #e7e9ea;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    min-height: 100vh;
}

/* ================= SIDEBAR ================= */

.admin-layout {
    display: flex;
    min-height: 100vh;
}

.sidebar {
    width: 240px;
    min-height: 100vh;
    background: #000;
    border-right: 1px solid #2f3336;
    padding: 18px 14px;
    position: fixed;
    left: 0;
    top: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
}

.sidebar-logo {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 12px 22px;
    font-size: 20px;
    font-weight: 700;
}

.sidebar-logo i {
    color: #1d9bf0;
    font-size: 24px;
}

.sidebar-menu {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.sidebar-item {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 13px 14px;
    border-radius: 10px;
    color: #71767b;
    text-decoration: none;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    border: none;
    background: transparent;
    text-align: left;
    transition: background 0.2s, color 0.2s;
}

.sidebar-item i {
    font-size: 19px;
    width: 22px;
}

.sidebar-item:hover {
    background: #16181c;
    color: #e7e9ea;
}

.sidebar-item.active {
    background: #16181c;
    color: #fff;
}

.sidebar-bottom {
    margin-top: auto;
}

.sidebar-logout {
    width: 100%;
    background: transparent;
    border: 1px solid #2f3336;
    color: #e7e9ea;
    padding: 10px;
    border-radius: 20px;
    cursor: pointer;
    font-size: 14px;
    transition: background 0.2s;
}

.sidebar-logout:hover {
    background: #16181c;
}

/* ================= MAIN ================= */

.admin-main {
    margin-left: 240px;
    width: calc(100% - 240px);
    min-height: 100vh;
}

.main-header {
    height: 64px;
    border-bottom: 1px solid #2f3336;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 28px;
    position: sticky;
    top: 0;
    z-index: 50;
    background: rgba(0,0,0,0.88);
    backdrop-filter: blur(12px);
}

.main-header h1 {
    font-size: 20px;
    font-weight: 700;
}

.admin-welcome {
    color: #71767b;
    font-size: 14px;
}

.admin-welcome strong {
    color: #e7e9ea;
}

/* ================= CONTENT ================= */

.container {
    max-width: 1100px;
    margin: 0 auto;
    padding: 28px;
}

/* ================= STATS ================= */

.stats-row {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 14px;
    margin-bottom: 28px;
}

.stat-card {
    background: #16181c;
    border: 1px solid #2f3336;
    border-radius: 14px;
    padding: 20px;
}

.stat-card .stat-num {
    font-size: 28px;
    font-weight: 800;
    color: #1d9bf0;
}

.stat-card .stat-label {
    font-size: 13px;
    color: #71767b;
    margin-top: 6px;
}

/* ================= TABS ================= */

.tabs {
    display: none;
}

.tab-panel {
    display: none;
}

.tab-panel.active {
    display: block;
}

/* ================= SECTION ================= */

.section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 16px;
}

.section-header h2 {
    font-size: 18px;
    font-weight: 700;
}

/* ================= TABLE ================= */

.admin-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
    background: #050505;
    border: 1px solid #2f3336;
    border-radius: 12px;
    overflow: hidden;
}

.admin-table th {
    text-align: left;
    padding: 12px;
    color: #71767b;
    font-weight: 600;
    border-bottom: 1px solid #2f3336;
    font-size: 13px;
}

.admin-table td {
    padding: 12px;
    border-bottom: 1px solid #1a1a1a;
    vertical-align: middle;
}

.admin-table tr:hover td {
    background: #0d0d0d;
}

.badge-verified {
    background: #1d9bf0;
    color: #fff;
    font-size: 11px;
    padding: 3px 8px;
    border-radius: 10px;
    font-weight: 600;
}

.badge-unverified {
    background: #2f3336;
    color: #71767b;
    font-size: 11px;
    padding: 3px 8px;
    border-radius: 10px;
}

.badge-pending {
    background: #ffa500;
    color: #000;
    font-size: 11px;
    padding: 3px 8px;
    border-radius: 10px;
    font-weight: 600;
}

.badge-resolved {
    background: #00ba7c;
    color: #000;
    font-size: 11px;
    padding: 3px 8px;
    border-radius: 10px;
    font-weight: 600;
}

/* ================= ACTIONS ================= */

.btn-action {
    border: none;
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    margin-right: 4px;
    transition: opacity 0.2s;
}

.btn-action:hover {
    opacity: 0.8;
}

.btn-verify {
    background: #1d9bf0;
    color: #fff;
}

.btn-unverify {
    background: #2f3336;
    color: #e7e9ea;
}

.btn-delete {
    background: #f4212e;
    color: #fff;
}

.btn-resolve {
    background: #00ba7c;
    color: #000;
}

/* ================= TWEET ================= */

.tweet-truncate {
    max-width: 320px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    color: #e7e9ea;
}

/* ================= EMPTY ================= */

.empty-state {
    text-align: center;
    color: #71767b;
    padding: 48px 0;
    font-size: 15px;
}

.empty-state i {
    font-size: 36px;
    display: block;
    margin-bottom: 10px;
}

/* ================= MOBILE ================= */

@media (max-width: 800px) {

    .sidebar {
        width: 70px;
        padding: 14px 8px;
    }

    .sidebar-logo span,
    .sidebar-item span,
    .sidebar-logout span {
        display: none;
    }

    .sidebar-logo {
        justify-content: center;
    }

    .sidebar-item {
        justify-content: center;
        padding: 13px;
    }

    .sidebar-item i {
        margin: 0;
    }

    .admin-main {
        margin-left: 70px;
        width: calc(100% - 70px);
    }

    .stats-row {
        grid-template-columns: repeat(2, 1fr);
    }

    .container {
        padding: 18px;
        overflow-x: auto;
    }
}

@media (max-width: 500px) {

    .stats-row {
        grid-template-columns: 1fr;
    }

    .main-header {
        padding: 0 16px;
    }
}
    </style>
</head>
<body>
<form id="form1" runat="server">

<div class="admin-layout">

    <!-- ================= SIDEBAR ================= -->

    <aside class="sidebar">

        <div class="sidebar-logo">
            <i class="bi bi-shield-fill-check"></i>
            <span>EliteTweet</span>
        </div>

        <div class="sidebar-menu">

            <button type="button"
                    class="sidebar-item active"
                    onclick="switchTab('users', this)">
                <i class="bi bi-people"></i>
                <span>Users</span>
            </button>

            <button type="button"
                    class="sidebar-item"
                    onclick="switchTab('tweets', this)">
                <i class="bi bi-chat-left-text"></i>
                <span>Tweets</span>
            </button>

            <button type="button"
                    class="sidebar-item"
                    onclick="switchTab('reports', this)">
                <i class="bi bi-flag"></i>
                <span>Reports</span>
            </button>
            <button type="button"
                    class="sidebar-item"
                    onclick="switchTab('verification', this)">
                <i class="bi bi-patch-check"></i>
                <span>Verification Requests</span>
            </button>

        </div>

        <div class="sidebar-bottom">

            <asp:Button
                ID="btnLogout"
                runat="server"
                Text="Logout"
                CssClass="sidebar-logout"
                OnClick="btnLogout_Click" />

        </div>

    </aside>


    <!-- ================= MAIN CONTENT ================= -->

    <main class="admin-main">

        <div class="main-header">

            <h1>Admin Dashboard</h1>

            <div class="admin-welcome">
                Welcome, <strong>Admin</strong>
            </div>

        </div>


        <div class="container">

            <!-- ================= STATS ================= -->

            <div class="stats-row">

                <div class="stat-card">
                    <div class="stat-num">
                        <asp:Label ID="lblTotalUsers" runat="server" Text="0" />
                    </div>
                    <div class="stat-label">
                        <i class="bi bi-people"></i>
                        Total Users
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-num">
                        <asp:Label ID="lblTotalTweets" runat="server" Text="0" />
                    </div>
                    <div class="stat-label">
                        <i class="bi bi-chat-left-text"></i>
                        Total Tweets
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-num">
                        <asp:Label ID="lblVerifiedUsers" runat="server" Text="0" />
                    </div>
                    <div class="stat-label">
                        <i class="bi bi-patch-check"></i>
                        Verified Users
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-num">
                        <asp:Label ID="lblPendingReports" runat="server" Text="0" />
                    </div>
                    <div class="stat-label">
                        <i class="bi bi-flag"></i>
                        Pending Reports
                    </div>
                </div>

            </div>


            <!-- ================= USERS ================= -->

            <div id="tab-users" class="tab-panel active">

                <div class="section-header">
                    <h2>All Users</h2>
                </div>

                <asp:Panel ID="pnlNoUsers" runat="server" Visible="false">
                    <div class="empty-state">
                        <i class="bi bi-people"></i>
                        No users found.
                    </div>
                </asp:Panel>

                <asp:Repeater ID="rptUsers"
                    runat="server"
                    OnItemCommand="rptUsers_ItemCommand">

                    <HeaderTemplate>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>

                    <ItemTemplate>

                        <tr>

                            <td style="color:#71767b;">
                                <%# Eval("UserId") %>
                            </td>

                            <td>
                                <strong><%# Eval("Name") %></strong>
                            </td>

                            <td style="color:#71767b;">
                                @<%# Eval("Username") %>
                            </td>

                            <td style="color:#71767b;">
                                <%# Eval("Email") %>
                            </td>

                            <td>
                                <%# Convert.ToBoolean(Eval("IsVerified"))
                                    ? "<span class='badge-verified'>✓ Verified</span>"
                                    : "<span class='badge-unverified'>Unverified</span>" %>
                            </td>

                            <td>

                                <asp:LinkButton
                                    runat="server"
                                    CommandName='<%# Convert.ToBoolean(Eval("IsVerified")) ? "Unverify" : "Verify" %>'
                                    CommandArgument='<%# Eval("Email") %>'
                                    CssClass='<%# "btn-action " + (Convert.ToBoolean(Eval("IsVerified")) ? "btn-unverify" : "btn-verify") %>'
                                    Text='<%# Convert.ToBoolean(Eval("IsVerified")) ? "Unverify" : "Verify" %>'
                                    OnClientClick="return confirm('Are you sure?');" />

                                <asp:LinkButton
                                    runat="server"
                                    CommandName="DeleteUser"
                                    CommandArgument='<%# Eval("Email") %>'
                                    CssClass="btn-action btn-delete"
                                    Text="Delete"
                                    OnClientClick="return confirm('Delete this user permanently?');" />

                            </td>

                        </tr>

                    </ItemTemplate>

                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>

                </asp:Repeater>

            </div>


            <!-- ================= TWEETS ================= -->

            <div id="tab-tweets" class="tab-panel">

                <div class="section-header">
                    <h2>All Tweets</h2>
                </div>

                <asp:Panel ID="pnlNoTweets" runat="server" Visible="false">
                    <div class="empty-state">
                        <i class="bi bi-chat-left-text"></i>
                        No tweets found.
                    </div>
                </asp:Panel>

                <asp:Repeater
                    ID="rptTweets"
                    runat="server"
                    OnItemCommand="rptTweets_ItemCommand">

                    <HeaderTemplate>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>User</th>
                                    <th>Tweet</th>
                                    <th>Posted</th>
                                    <th>Likes</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>

                    <ItemTemplate>

                        <tr>

                            <td style="color:#71767b;">
                                <%# Eval("TweetId") %>
                            </td>

                            <td>
                                <strong><%# Eval("Name") %></strong><br />
                                <span style="color:#71767b;font-size:12px;">
                                    @<%# Eval("Username") %>
                                </span>
                            </td>

                            <td>
                                <div class="tweet-truncate">
                                    <%# Eval("TweetText") %>
                                </div>
                            </td>

                            <td style="color:#71767b;font-size:12px;">
                                <%# GetTimeAgo((DateTime)Eval("CreatedAt")) %>
                            </td>

                            <td style="color:#f91880;">
                                <%# Eval("LikeCount") %>
                                <i class="bi bi-heart-fill" style="font-size:11px;"></i>
                            </td>

                            <td>

                                <asp:LinkButton
                                    runat="server"
                                    CommandName="DeleteTweet"
                                    CommandArgument='<%# Eval("TweetId") %>'
                                    CssClass="btn-action btn-delete"
                                    Text="Delete"
                                    OnClientClick="return confirm('Delete this tweet?');" />

                            </td>

                        </tr>

                    </ItemTemplate>

                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>

                </asp:Repeater>

            </div>


            <!-- ================= REPORTS ================= -->

            <div id="tab-reports" class="tab-panel">

                <div class="section-header">
                    <h2>Reports &amp; Complaints</h2>
                </div>

                <asp:Panel ID="pnlNoReports" runat="server" Visible="false">
                    <div class="empty-state">
                        <i class="bi bi-flag"></i>
                        No reports yet.
                    </div>
                </asp:Panel>

                <asp:Repeater
                    ID="rptReports"
                    runat="server"
                    OnItemCommand="rptReports_ItemCommand">

                    <HeaderTemplate>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Reported By</th>
                                    <th>Reason</th>
                                    <th>Tweet / User</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>

                    <ItemTemplate>

                        <tr>

                            <td style="color:#71767b;">
                                <%# Eval("ReportId") %>
                            </td>

                            <td style="color:#71767b;">
                                <%# Eval("ReporterEmail") %>
                            </td>

                            <td>
                                <%# Eval("Reason") %>
                            </td>

                            <td style="color:#71767b;font-size:12px;">

                                <%# Eval("ReportedTweetId") != DBNull.Value
                                    ? "Tweet #" + Eval("ReportedTweetId")
                                    : "" %>

                                <%# Eval("ReportedEmail") != DBNull.Value &&
                                    Eval("ReportedEmail").ToString() != ""
                                    ? "@" + Eval("ReportedEmail")
                                    : "" %>

                            </td>

                            <td style="color:#71767b;font-size:12px;">
                                <%# GetTimeAgo((DateTime)Eval("CreatedAt")) %>
                            </td>

                            <td>

                                <%# Eval("Status").ToString() == "Pending"
                                    ? "<span class='badge-pending'>Pending</span>"
                                    : "<span class='badge-resolved'>Resolved</span>" %>

                            </td>

                            <td>

                                <asp:LinkButton
                                    runat="server"
                                    CommandName="Resolve"
                                    CommandArgument='<%# Eval("ReportId") %>'
                                    CssClass="btn-action btn-resolve"
                                    Text="Resolve"
                                    Visible='<%# Eval("Status").ToString() == "Pending" %>' />

                                <asp:LinkButton
                                    runat="server"
                                    CommandName="DeleteReport"
                                    CommandArgument='<%# Eval("ReportId") %>'
                                    CssClass="btn-action btn-delete"
                                    Text="Delete"
                                    OnClientClick="return confirm('Delete this report?');" />

                            </td>

                        </tr>

                    </ItemTemplate>

                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>

                </asp:Repeater>

            </div>

            <!-- ================= VERIFICATION REQUESTS ================= -->

        <div id="tab-verification" class="tab-panel">

            <div class="section-header">
                <h2>Verification Requests</h2>
            </div>

            <asp:Panel ID="pnlNoVerificationRequests"
                runat="server"
                Visible="false">

                <div class="empty-state">
                    <i class="bi bi-patch-check"></i>
                    No pending verification requests.
                </div>

            </asp:Panel>

            <asp:Repeater ID="rptVerificationRequests"
                runat="server"
                OnItemCommand="rptVerificationRequests_ItemCommand">

                <HeaderTemplate>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>

                <ItemTemplate>
                    <tr>

                        <td style="color:#71767b;">
                            <%# Eval("UserId") %>
                        </td>

                        <td>
                            <strong><%# Eval("Name") %></strong>
                        </td>

                        <td style="color:#71767b;">
                            @<%# Eval("Username") %>
                        </td>

                        <td style="color:#71767b;">
                            <%# Eval("Email") %>
                        </td>

                        <td>

                            <asp:LinkButton
                                runat="server"
                                CommandName="Approve"
                                CommandArgument='<%# Eval("Email") %>'
                                CssClass="btn-action btn-verify"
                                Text="Approve"
                                OnClientClick="return confirm('Approve this verification request?');" />

                            <asp:LinkButton
                                runat="server"
                                CommandName="Reject"
                                CommandArgument='<%# Eval("Email") %>'
                                CssClass="btn-action btn-delete"
                                Text="Reject"
                                OnClientClick="return confirm('Reject this verification request?');" />

                        </td>

                    </tr>
                </ItemTemplate>

                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>

            </asp:Repeater>

        </div>

        </div>

    </main>

</div>

</form>

<script>
    function switchTab(tabName, btn) {

        document.querySelectorAll('.tab-panel').forEach(function (panel) {
            panel.classList.remove('active');
        });

        document.querySelectorAll('.sidebar-item').forEach(function (item) {
            item.classList.remove('active');
        });

        document.getElementById('tab-' + tabName).classList.add('active');

        btn.classList.add('active');
    }
</script>
</body>
</html>
