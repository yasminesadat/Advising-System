<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="change33.aspx.cs" Inherits="Advising_System.change33" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Graduation Plan</title>
    <link rel="stylesheet" type="text/css" href="Styles.css" />
</head>
<body class="body2">
    <form id="form1" runat="server">
        <center>
            <h1>View Graduation Plan</h1>
        <div>

            <asp:Label ID="Label1" runat="server" Text="Student ID: " CssClass="White"></asp:Label>


               <asp:TextBox ID="std" runat="server"></asp:TextBox>
            <asp:Button ID="info" runat="server" Text="Enter" OnClick="move" CssClass="button"/>
            <br />
            <asp:Label ID="stds" runat="server" Text=""></asp:Label>
        </div>
        <div>
            <asp:Button runat="server" OnClick ="RETURN" Text="Previous Page" CssClass="button"></asp:Button>&nbsp;</div>
            </center>
    </form>
</body>
</html>
