<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin_Login.aspx.cs" Inherits="WebApplication1.Admin_Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login</title>
    <link rel="stylesheet" type="text/css" href="styles2.css" />

    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .wrapper{
            animation:none;
        }

        .DivCenter {
            text-align: center;
            padding: 20px;
            border: 1px solid #ccc;
            background-color: rgba(255, 255, 255, 0.3);
            border-radius:8px;
        }
        .header{
        background-color: orange;
        height: 10%;
        width:100%;
        margin-bottom:30%;

        }
        h1{
            opacity:100;
            animation:none;
        }
    </style>
</head>
<body class="wrapper">
    <form id="form1" runat="server">
        <center><h1>Admin Login</h1></center>
        <div class="DivCenter">
            Please enter your credentials:<br />
            <br />
            ID:<br />
            <asp:TextBox ID="username" runat="server"></asp:TextBox>
            <br />
            Password:<br />
            <asp:TextBox ID="password" runat="server"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="login" runat="server" OnClick="loginpressed" Text="Login" CssClass="button" />
        </div>
        <center></center>
        <p>
            &nbsp;</p>
        <p>
            <center><asp:Button ID="Button1" runat="server" OnClick="ReturnMP" Text="Return to Main Page" CssClass="button" /></center>
        </p>
    </form>
        
</body>
</html>