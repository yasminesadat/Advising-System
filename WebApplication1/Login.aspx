<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Advising_System.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Login</title>
    <link rel="stylesheet" type="text/css" href="styles.css" />
     <style>
     body {
         display: flex;
         align-items: center;
         justify-content: center;
         height: 100vh;
         margin: 0;
     }

     .DivCenter {
         text-align: center;
         padding: 20px;
         border: 1px solid #ccc;
     }
     .Texts{
         color:white
     }
 </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <center><h1>Student Login</h1></center><br />
            <div class="DivCenter">
                Please enter your credentials <br /> <br />
             Student ID:<br />
             <asp:TextBox ID="studid" runat="server"></asp:TextBox>
             <br />
             Password:<br />
             <asp:TextBox ID="password" runat="server"></asp:TextBox>
             <br />
            <br /><asp:Button ID="loginf" runat="server" OnClick="loginfe3lan" Text="Log In" CssClass="button"/>
            <br />
           
            <br />
                </div>
            <center>
             <br /><asp:Label ID="Label2" runat="server" Text=""></asp:Label>
             <br /><div style="color: white;text-shadow: 1px 1px 1px black;">Don't have an account?</div><br />
             <br /><asp:Button ID="Button1" runat="server" OnClick="reg" Text="Register" CssClass="button"/>
             <br /><asp:Button ID="Button2" runat="server" OnClick="ReturnMP" Text="Exit" CssClass="button" style="position: fixed; top: 30px;  right: 50px;"/>
                </center>

        </div>
    </form>
</body>
</html>
