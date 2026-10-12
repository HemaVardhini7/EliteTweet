<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="EliteTweet.AdminLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login / EliteTweet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        body {
            background: #000;
            min-height: 100vh;
        }

        .admin-card {
            background-color: #000;
            color: #fff;
            border-radius: 15px;
            max-width: 380px;
            width: 100%;
/*            border: 1px solid white;*/
        }

        label { color: #8899a6; }

        .form-control {
            background-color: #1a1a1a;
            border: 1px solid #333;
            color: #fff;
        }
        .form-control:focus {
            background-color: #1a1a1a;
            border-color: #1d9bf0;
            color: #fff;
            box-shadow: none;
        }
        .form-control::placeholder { color: #555; }

        .btn-admin {
            background-color: #1d9bf0;
            color: #fff;
            border: none;
            border-radius: 20px;
            font-weight: 700;
            font-size: 16px;
            padding: 10px;
        }
        .btn-admin:hover { background-color: #1a8cd8; }

        .admin-badge {
            background-color: #1d9bf0;
            color: #fff;
            border-radius: 8px;
            padding: 4px 12px;
            font-size: 13px;
            font-weight: 600;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="container d-flex justify-content-center align-items-center min-vh-100">
        <div class="admin-card p-4 shadow">

            <!-- Header -->
            <div class="text-center mb-4">
                <i class="bi bi-twitter-x" style="font-size:32px;"></i>
                <div class="mt-2">
                    <span class="admin-badge"><i class="bi bi-shield-check me-1"></i>Admin Panel</span>
                </div>
                <h5 class="mt-3 fw-bold">Sign in to Admin</h5>
                <p style="color:#71767b; font-size:13px;">This area is restricted to administrators only.</p>
            </div>

            <!-- Error message -->
            <asp:Label ID="lblError" runat="server" CssClass="text-danger d-block mb-3 text-center" Visible="false" />

            <!-- Username -->
            <div class="mb-3">
                <label>Username</label>
                <asp:TextBox ID="txtUsername" runat="server"
                    CssClass="form-control"
                    placeholder="Enter admin username" />
            </div>

            <!-- Password -->
            <div class="mb-4">
                <label>Password</label>
                <asp:TextBox ID="txtPassword" runat="server"
                    CssClass="form-control"
                    TextMode="Password"
                    placeholder="Enter admin password" />
            </div>

            <!-- Login Button -->
            <div class="d-grid">
                <asp:Button ID="btnLogin" runat="server"
                    Text="Sign In"
                    CssClass="btn btn-admin"
                    OnClick="btnLogin_Click" />
            </div>

            <!-- Back to site -->
            <div class="text-center mt-3">
                <a href="FirstPage.aspx" style="color:#1d9bf0; font-size:14px;">
                    <i class="bi bi-arrow-left me-1"></i>Back to EliteTweet
                </a>
            </div>

        </div>
    </div>
</form>
</body>
</html>
