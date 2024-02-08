<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="makeup22.aspx.cs" Inherits="Advising_System.makeup22" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Second Makeup</title>
    <link rel="stylesheet" type="text/css" href="Styles.css" />
</head>
<body class="body2">
    <form id="form1" runat="server">
        <center>
            <h1>Register for Second Makeup</h1>
            
        <div>
            <asp:Label ID="Label1" runat="server" Text="StudentID:" CssClass="White"></asp:Label>
        </div>
        <div>
            <asp:TextBox ID="std" runat="server"></asp:TextBox>
            &nbsp;
        </div>
        <div>
            <asp:Label ID="Label2" runat="server" Text="CourseID:" CssClass="White"></asp:Label>
            &nbsp;
        </div>
        <div>
            <asp:TextBox ID="cid" runat="server"></asp:TextBox>
            &nbsp;
        </div>
        <div>
            <asp:Label ID="Label3" runat="server" Text="Semester Code:" CssClass="White"></asp:Label>
            &nbsp;
            <br />
        </div>
        <div>
            <asp:TextBox ID="semc" runat="server"></asp:TextBox>
            &nbsp;
        </div>
        <div>
            <asp:Button ID="temp" runat="server" OnClick="proceed" Text="Enter" CssClass="button"></asp:Button>
            &nbsp;
        </div>
        <div>&nbsp;</div>
        <div>
            <asp:Button ID ="Return" Onclick ="RETURN" runat="server" Text="Previous Page" CssClass="button"></asp:Button>&nbsp;</div>
        <asp:Label ID="result" runat="server" Text=" "></asp:Label> 
            </center>
    </form>
</body>
</html>
