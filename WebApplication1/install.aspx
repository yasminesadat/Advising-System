<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="install.aspx.cs" Inherits="Advising_System.install" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Installment</title>
    <link rel="stylesheet" type="text/css" href="Styles.css" />
</head>
<body class="body2">
    <form id="form1" runat="server">
        <center>
            <h1>View Installments</h1>
        <div>
            <asp:Label ID="Label1" runat="server" Text="Please enter your Student ID:" CssClass="White"></asp:Label>
            <br />
        </div>
  
        <div>
            <asp:TextBox ID ="std" runat="server"></asp:TextBox>&nbsp;</div>
            <br />
        <div>

            <asp:Button ID="move" runat="server" Text="Enter" OnClick="move_Click" CssClass="button"></asp:Button>&nbsp;<asp:Button runat="server" Onclick ="RETURN" Text="Previous Page" CssClass="button"></asp:Button></div>
        <div>
            <asp:Label runat="server" Text="Result : " CssClass="White"></asp:Label><asp:Label ID ="results" runat="server" Text=" " CssClass="White"></asp:Label>&nbsp;</div>
    </center>
            </form>
</body>
</html>
