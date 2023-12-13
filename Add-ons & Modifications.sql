--------------------------------- Modified Section -----------------------------------------

------------------------Accept/Reject Credit hours request ---------------------------------
Go
Create PROC [Procedures_AdvisorApproveRejectCHRequest]
@requestID int,
@current_sem_code varchar(40),
@stat varchar(40) output
As 

declare 
@requestCreditHours int,
@type varchar(40),  -- 0 ch
@studentGPA decimal(10,2),
@studentCH  int,

@new_studentCH int,
@studentid int,
@paymentid int,
@nextinstalldate date

select @studentid = Request.student_id from Request where Request.request_id = @requestID
select @studentGPA = Student.gpa from Student where Student.student_id = @studentid
select @studentCH = Student.assigned_hours from Student where Student.student_id = @studentid
select @requestCreditHours = Request.credit_hours from Request where Request.request_id = @requestID
select @type = Request.type from Request where Request.request_id = @requestID
set @new_studentCH = @studentCH

if @type like '%credit%' and @studentCH + @requestCreditHours<=34 and @studentGPA < 3.7 and @requestCreditHours<=3
Begin
set @stat = 'Accept' 
set @new_studentCH = @studentCH + @requestCreditHours

update Student
set student.assigned_hours = @new_studentCH
where Student.student_id = @studentid

select @paymentid = payment.payment_id from Payment where payment.student_id = @studentid and semester_code = @current_sem_code
Select Top 1 @nextinstalldate =  Installment.startdate from Installment where installment.status = 'notPaid' order by Installment.startdate ASC 

update installment
set installment.amount = installment.amount + (1000*@requestCreditHours)
where payment_id = @paymentid and Installment.startdate =@nextinstalldate

update Payment
set payment.amount = payment.amount + (1000*@requestCreditHours)
where payment_id = @paymentid
END
Else
set @stat = 'Reject'

update Request
set request.status = @stat
where Request.request_id = @requestID

Go

GO
CREATE PROC Check_Major
@major varchar(40),
@exists bit output
AS
SET @exists=CASE WHEN (EXISTS(SELECT * FROM Student WHERE @major=major)) THEN 1 ELSE 0 END;
GO

GO
CREATE PROC Check_Request_Exists
@requestID int,
@advisorID int,
@exists bit output
AS
SET @exists=CASE WHEN (EXISTS(SELECT * FROM Request WHERE @requestID=request_id AND @advisorID=advisor_id)) THEN 1 ELSE 0 END;
GO

GO
CREATE PROC Check_Request_Pending
@requestID int,
@pending bit output
AS
SET @pending=CASE WHEN (EXISTS(SELECT * FROM Request WHERE @requestID=request_id AND status LIKE '%pending%')) THEN 1 ELSE 0 END;
GO

------------------Approve/Reject courses request based on the student’s assigned credit hours ------------------
Go
Create PROC [Procedures_AdvisorApproveRejectCourseRequest]
@requestID int,
@current_semester_code varchar(40),
@status varchar(40) output

As 

declare 
@type varchar(40),  -- 1 course
@studentah  int,
@studentid int,
@requestcourse_id int,
@course_hours int,
@new_studentah int,
@isoffered bit,
@prerequiste bit,
@instructor_id int

select @studentid = Request.student_id from Request where Request.request_id = @requestID
select @studentah = Student.assigned_hours from Student where Student.student_id = @studentid
select @requestcourse_id = Request.course_id from Request where Request.request_id = @requestID
select @type = Request.type from Request where Request.request_id = @requestID
select @course_hours = Course.credit_hours from course where Course.course_id = @requestcourse_id
select @isoffered = Course.is_offered from course where Course.course_id = @requestcourse_id

set @prerequiste = dbo.FN_check_prerequiste(@studentid,@requestcourse_id)
set @new_studentah = @studentah

if @type like '%course%' and @studentah >= @course_hours and @isoffered = 1 and @prerequiste = 1
Begin
set @status = 'Accept' 
set @new_studentah = @new_studentah - @course_hours
insert into Student_Instructor_Course_take (student_id, course_id,semester_code) values (@studentid,@requestcourse_id,@current_semester_code)
select *
from Student_Instructor_Course_take
END
Else
set @status = 'Reject'

update Request
set request.status = @status
where Request.request_id = @requestID

update Student
set student.assigned_hours = @new_studentah
where Student.student_id = @studentid
Go

--------------------------------Insert graduation plan ---------------------------------------------

Go
CREATE PROC [Procedures_AdvisorCreateGP]

@Semester_code varchar(40), 
@expected_graduation_date date, 
@sem_credit_hours int,
@advisor_id int,
@student_id int,
@sucess bit output

AS
declare @res bit=0
declare @student_acquired int 
Select @student_acquired  =  Student.acquired_hours from  Student where Student.student_id = @student_id
If(@student_acquired >=157)
BEGIN
insert into Graduation_Plan values (@Semester_code, @sem_credit_hours, @expected_graduation_date, @advisor_id, @student_id)
set @res=1
END
set @sucess=@res;
GO
--------------------------------------------------------------
----------- ADDITIONS FOR UI DEFENSIVE MESSAGES---------------
GO
CREATE Proc View_Advisor_Students
@advisorID int
AS 
Select student_id,f_name+' '+l_name 'name',major,faculty,semester,gpa,email,financial_status,acquired_hours,assigned_hours FROM Student Where advisor_id=@advisorID;
GO


GO
CREATE Proc Check_Advisor_Exists
@email  varchar(40),
@exists bit output
AS
SET @exists=CASE WHEN (EXISTS(SELECT * FROM Advisor WHERE @email=email)) THEN 1 ELSE 0 END;
GO


GO
CREATE PROC Check_Plan
@Semester_code varchar(40), 
@student_id int,
@advisorID int,
@exists bit output,
@valid bit output
AS
SET @exists=CASE WHEN (EXISTS(SELECT * FROM Graduation_Plan WHERE @Semester_code=semester_code AND @student_id=student_id)) THEN 1 ELSE 0 END;

SET @valid=CASE WHEN (EXISTS (SELECT * FROM Student WHERE student_id=@student_id AND advisor_id=@advisorID)) AND EXISTS((SELECT * FROM Semester WHERE semester_code=@Semester_code)) THEN 1 ELSE 0 END;
GO


GO
CREATE PROC Check_Update_Plan
@student_id int,
@advisor_id int,
@valid bit output
AS
SET @valid=CASE WHEN (EXISTS(SELECT * FROM Graduation_Plan GP  
WHERE GP.student_id=@student_id AND GP.advisor_id=@advisor_id)) THEN 1 ELSE 0 END;
GO


GO
CREATE PROC Check_GradPlan_Course
@sem_code varchar(40),
@student_id int,
@courseID int,
@advisor_id int,
@exists bit output,
@courseFound bit output
AS
SET @exists=CASE WHEN (EXISTS(SELECT * FROM Graduation_Plan GP  
WHERE GP.student_id=@student_id AND GP.advisor_id=@advisor_id AND GP.semester_code=@sem_code)) THEN 1 ELSE 0 END;

SET @courseFound=CASE WHEN (EXISTS(SELECT * FROM Graduation_Plan GP 
INNER JOIN GradPlan_Course GPC ON GPC.plan_id=GP.plan_id 
WHERE GP.student_id=@student_id AND GP.advisor_id=@advisor_id AND @sem_code= GPC.semester_code
AND GPC.course_id=@courseID))
THEN 1 ELSE 0 END;
GO


GO
CREATE PROC Check_Insert_GPCourse
@Semester_code varchar(40), 
@student_id int,
@advisorID int,
@course_name varchar(40),
@exists bit output,
@courseFound bit output,
@courseInPlan bit output
AS
SET @exists=CASE WHEN (EXISTS(SELECT * FROM Graduation_Plan WHERE @Semester_code=semester_code AND @student_id=student_id AND advisor_id=@advisorID)) THEN 1 ELSE 0 END;

DECLARE @stud_major VARCHAR(40);
SELECT @stud_major = major FROM student WHERE student_id = @student_id;

SET @courseFound=CASE WHEN EXISTS(SELECT * FROM Course WHERE name=@course_name AND major=@stud_major) THEN 1 ELSE 0 END;

SET @courseInPlan=CASE WHEN (EXISTS(SELECT * FROM Graduation_Plan GP 
INNER JOIN GradPlan_Course GPC ON GPC.plan_id=GP.plan_id INNER JOIN Course C ON C.course_id=GPC.course_id
WHERE GP.student_id=@student_id AND GP.advisor_id=@advisorID AND @Semester_code= GPC.semester_code
AND C.name=@course_name)) THEN 1 ELSE 0 END;
GO

