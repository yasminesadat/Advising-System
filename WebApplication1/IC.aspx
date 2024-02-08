<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IC.aspx.cs" Inherits="Advising_System.IC" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Choose Instructor/Course</title>
    <link rel="stylesheet" type="text/css" href="Styles.css" />
</head>
<body class="body2">
    <form id="form1" runat="server">
        <center>
            <h1>Choose Instructor and Course</h1>
        <div>
            <asp:Label ID="Label1" runat="server" Text="StudentID:" CssClass="White"></asp:Label>
            &nbsp;
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
            <asp:Label ID="Label4" runat="server" Text="Instructor ID:" CssClass="White"></asp:Label>
            &nbsp;
        </div>
        <div>
            <asp:TextBox ID="instid" runat="server"></asp:TextBox>
            &nbsp;
        </div>
        <div>
            <asp:Label ID="Label3" runat="server" Text="Semester Code:" CssClass="White"></asp:Label>
            &nbsp;
        </div>
        <div>
            <asp:TextBox ID="semc" runat="server"></asp:TextBox>
            &nbsp;
        </div>
        <div>
            <asp:Button runat="server" OnClick="pro" Text="Enter" CssClass="button"></asp:Button>
            &nbsp;
        </div>
        <div>
            
            &nbsp;</div>
        <div>&nbsp;<asp:Button ID ="return" runat="server" Onclick ="RETURN" Text="Previous Page" CssClass="button"></asp:Button></div>
        <asp:Label ID="result" runat="server" Text=""></asp:Label> 
            </center>
    </form>
</body>
</html>
