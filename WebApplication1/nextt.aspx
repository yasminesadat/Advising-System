<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="nextt.aspx.cs" Inherits="Advising_System.nextt" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Instructor/Course</title>
    <link rel="stylesheet" type="text/css" href="Styles.css" />
</head>
<body class="body2">
    <form id="form1" runat="server">
        <center>
            <h1>View Instructor and Course</h1>
        <div>
             <div>

     <asp:Label ID="Label1" runat="server" Text="Instructor ID: " CssClass="White"></asp:Label>


        <asp:TextBox ID="std" runat="server"></asp:TextBox>
     <br />
 </div>
     <asp:Label ID="Label2" runat="server" Text="Course ID: " CssClass="White"></asp:Label> 
        <asp:TextBox ID="std2" runat="server"></asp:TextBox>

            <div> 
     <asp:Button ID="move" runat="server" Text="Enter" OnClick="nexting" CssClass="button"/>
                 
                &nbsp;</div>
    
            <div>  <asp:Label ID="result0" runat="server" Text=" "></asp:Label><asp:Button runat="server" OnClick ="RETURN" Text="Previous Page" CssClass="button"></asp:Button></div>
            
        </div>
            </center>
    </form>
</body>
</html>
