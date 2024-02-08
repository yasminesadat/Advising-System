<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="General.aspx.cs" Inherits="Advising_System.General" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Hom Page 2</title>
    <link rel="stylesheet" type="text/css" href="Styles.css" />
    <style>
        
        #form1 {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
        }

        #form1 div {
            margin-right: 10px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body class="body2">
    <form id="form1" runat="server">
        
        <br />
        <br />
        <br />
        <span class="button-container small-buttons">
        <div>
            <asp:Button ID="Button1" runat="server" OnClick="change" Text="Exams / Courses" CssClass="button"/>
        </div>
        <div>
            <asp:Button ID="Button3" runat="server" OnClick="change2" Text="Slots / Instructors" CssClass="button"/>
        </div>
        <div>
            <asp:Button ID="Button4" runat="server" OnClick="change1" Text="Course Prereq" CssClass="button"/> 
        </div>



        <div>
            <asp:Button ID="Button2" runat="server" OnClick="modifyrecords" Text="Modify Records" CssClass="button"></asp:Button>
        </div>
                    <asp:Button ID="Button5" runat="server" OnClick="StudentOne" Text="Return" CssClass="button"></asp:Button>

   </span>
            </form>
</body>
</html>
