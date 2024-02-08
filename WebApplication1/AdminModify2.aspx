<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminModify2.aspx.cs" Inherits="WebApplication1.AdminModify2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Modifying 2</title>
    <link rel="stylesheet" type="text/css" href="Styles.css" />
</head>
<body class="body2">
    <form id="form1" runat="server">
        <div>
            <center>
                <h1>Modifying Records</h1>
                <asp:Button ID="return2" runat="server" OnClick="Return2" Text="Return to Admin Page 2" CssClass="button" />
            </center>
            <asp:Label ID="Label2" runat="server" Text=""></asp:Label>
        </div>
        <div class="row">
            <div class="column">
                Current Semester:<br />
                <asp:TextBox ID="cs" runat="server"></asp:TextBox>
                <br /><br/>
                <asp:Button ID="Button2" runat="server" OnClick="deleteslotfe3lan" Text="Delete slot" />
                <br /><br/>
                Payment ID:<br />
                <asp:TextBox ID="pid" runat="server"></asp:TextBox>
                <br />
                <br />
                <asp:Button ID="issueins" runat="server" OnClick="issueinsfe3lan" Text="Issue Installment" />
            </div>
            <div class="column">
                Add Exam for Course:<br/>
                Course ID:<br />
                <asp:TextBox ID="courseID" runat="server"></asp:TextBox>
                <br />
                <br />
                Type:<br />
                <asp:TextBox ID="type" runat="server"></asp:TextBox>
                <br />
                <br />
                Date:<br />
                <asp:TextBox ID="date" runat="server" type="date" OnTextChanged="examDate"></asp:TextBox>
                <br />
                <br />
                <asp:Button ID="buttonAddExam" runat="server" OnClick="AddExam" Text="Add" />
                <br /><br/>
                Update Financial Status:<br/>
                Student ID:<br />
                <asp:TextBox ID="studentID" runat="server"></asp:TextBox><br/><br/>
                <asp:Button ID="buttonStudent" runat="server" OnClick="UpdateStudent" Text="Submit" />

                  </div>
                <br />
                <br />
                <br />
              
                <div class="column alignLeft">
                    
                        <center>Delete a Course:</center>
                        
        <asp:Label ID="Label1" runat="server" Text="Please enter your Course ID:"></asp:Label>
   
    
       <center> <asp:TextBox ID ="cid" runat="server"></asp:TextBox>&nbsp;
   
        <asp:Button ID="move" runat="server" Text="Enter" OnClick="move_Click"></asp:Button>&nbsp;  </center>
   
        <asp:Label runat="server" Text="Result : "></asp:Label><asp:Label ID ="results" runat="server" Text=" "></asp:Label>&nbsp;





                    </div>
                </div>



          
    </form>
</body>
</html>