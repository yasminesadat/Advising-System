

GO
CREATE FUNCTION dbo.FN_StudentUpcoming_installment
(
    @StudentID int
)
RETURNS date
AS 
BEGIN
    DECLARE @CurrDate datetime = GETDATE()
    DECLARE @date datetime

    SELECT TOP 1 @date = i.deadline
    FROM Installment i
    INNER JOIN Payment p ON p.payment_id = i.payment_id
    INNER JOIN Student s ON s.student_id = p.student_id
    WHERE s.student_id = @StudentID AND i.status = 'notPaid'
    ORDER BY DATEDIFF(DAY, @CurrDate, i.deadline)

    RETURN @date
END;
GO

--INSERT INTO Installment VALUES(49,'2-20-2001',20,'notPaid','1-20-2001')
--declare @output date=dbo.FN_StudentUpcoming_installment(1);print @output

declare @output datetime
set @output= dbo.FN_StudentUpcoming_installment (5)
print (@output)
go

-------------------------------------------------

go
create function dbo.FN_StudentViewGP             
(
@student_ID int
)
returns table 
as return 
SELECT S.student_id,S.f_name+' '+S.l_name 'student_name', GP.plan_id,C.course_id,C.name 'course_name',GP.semester_code,GP.expected_grad_date,GP.semester_credit_hours,S.advisor_id
FROM Graduation_Plan GP INNER JOIN GradPlan_Course GC ON GC.plan_id=GP.plan_id
INNER JOIN Course C ON C.course_id=GC.course_id INNER JOIN Student S ON S.student_id=GP.student_id
WHERE GP.student_id=@student_ID;;
go

--INSERT INTO GradPlan_Course VALUES(1,'s23',1);
--Select * FROM dbo.FN_StudentViewGP (1)
----------------------------------------------
go
create function dbo.FN_StudentViewSlot
(
    @courseID int, @instructorID int

)
RETURNS table
AS return
SELECT S.slot_id,S.location,S.time, S.day, C.name 'course_name',I.name 'instructor_name' FROM Slot S  INNER JOIN Instructor I ON S.instructor_id=I.instructor_id
INNER JOIN Course C ON S.course_id=C.course_id
WHERE C.course_id=@courseID AND I.instructor_id=@instructorID;
go
--SELECT * FROM dbo.FN_StudentViewSlot (1,1)


------------------------------------------
create function dbo.FN_Advisors_Requests(
@advisorID int
)
returns @Result Table
(
request_id int, type varchar(40), comment varchar(40), status varchar(40), credit_hours int, student_id int, advisor_id int, course_id int
)
as
begin
insert into @Result(request_id, type, comment, status, credit_hours, student_id, advisor_id, course_id)
SELECT * FROM Request 
WHERE @advisorID = Request.advisor_id 


return
end
go



-------------------------------------------



create function dbo.FN_AdvisorLogin
(
    @Advisor_ID int ,
    @password varchar(40)

)
RETURNS Bit 
AS
Begin

DECLARE @confirm bit =0
DECLARE @username varchar(40)
DECLARE @password2 varchar(40)

SELECT @username = name FROM Advisor 
WHERE @Advisor_ID = advisor_id

SELECT @password2 = password FROM Advisor 
WHERE @username = name

IF @password=@password2
begin
set @confirm=1

end
return @confirm
end
go


-----------------------------------------------------------
create function dbo.FN_StudentLogin
(
    @Student_ID int ,
    @password varchar(40)

)
RETURNS Bit 
AS
Begin

DECLARE @confirm bit =0
DECLARE @username varchar(40)
DECLARE @password2 varchar(40)

SELECT @username = f_name FROM Student 
WHERE @Student_ID = student_id

SELECT @password2 = password FROM Student 
WHERE @username = f_name

IF @password=@password2
begin
set @confirm=1

end
return @confirm
end
go

------------------------------------------
create function dbo.SemesterAvailableCourses
(
    @semester_code varchar(40)

)
RETURNS @Result table (course_id int, course_name varchar(40))
AS
Begin
declare @course_id int

select @course_id=course_id from Course_Semester where @semester_code=semester_code

insert into @Result(course_id,course_name)
select course_id,name from Course where @course_id=course_id

return
end
go

--select * from dbo.SemesterAvailableCourses('w23')



--------------MM
go
create proc Procedures_ViewOptionalCourse
@StudentID int , @current_semester_code varchar(40)
as

SELECT * FROM Course C INNER JOIN Student S ON C.major = S.major INNER JOIN Course_Semester CS ON C.course_id = CS.course_id
WHERE S.student_id = @StudentID AND @current_semester_code <= CS.semester_code





go

drop proc Procedures_ViewOptionalCourse
exec Procedures_ViewOptionalCourse 5 , 'w23'


----EXCEPT (SELECT * FROM Course C2 INNER JOIN Student S2 ON C2.major = S2.major INNER JOIN Course_Semester CS2 ON CS2.course_id = C2.course_id WHERE @current_semester_code = CS2.semester_code)------
------------------



--NN
go
create proc Procedures_ViewMS
@StudentID int
as
DECLARE @current_semester_code varchar(40)
DECLARE @course_id varchar(40)

SELECT @course_id = course_id FROM Student S INNER JOIN Course C ON S.major = C.major  
WHERE S.student_id = @StudentID

SELECT @current_semester_code = S1.semester_code FROM Semester S1 INNER JOIN Course_Semester CS ON CS.course_id = @course_id

SELECT * FROM Course C INNER JOIN Student S ON C.major = S.major INNER JOIN Course_Semester CS ON C.course_id = CS.course_id
WHERE S.student_id = @StudentID
EXCEPT (SELECT * FROM Course C2 INNER JOIN Student S2 ON C2.major = S2.major INNER JOIN Course_Semester CS2 ON CS2.course_id = C2.course_id
WHERE @current_semester_code > CS2.semester_code)




go
------------------------------------------------------

exec Procedures_ViewMS 5 

SELECT * FROM Student
SELECT * FROM Semester
SELECT * FROM Course
SELECT * FROM Course_Semester
insert into Course values (4,'math -1' , 'MET' , 1 , 12 , 8)
insert into Semester values('w22' , '2003-04-09' , '2003-05-12')
insert into Course_Semester values(4, 'w22')

--X
GO
CREATE PROC Procedures_AdvisorViewAssignedStudents
@AdvisorID int, 
@major varchar(40)
as
SELECT Student.student_id, Student.f_name+ ' '+Student.l_name as name, Student.major, Course.name
from Student inner join Student_Instructor_Course_Take on Student.student_id=Student_Instructor_Course_Take.student_id
inner join Course on Course.course_id=Student_Instructor_Course_Take.course_id
where Student.advisor_id=@AdvisorID and Student.major=@major;;
GO
--exec Procedures_AdvisorViewAssignedStudents 1,'CS'

--Y 
GO
CREATE PROC Procedures_AdvisorApproveRejectCourseRequest  --? null instructor problem
@RequestID int,
@studentID int,
@advisorID int
AS
DECLARE @courseID int,
@assigned_hours int,
@credit_hrs int

SELECT @courseID=course_id FROM Request 
WHERE @RequestID=request_id AND @studentID=student_id AND @advisorID=advisor_id;

SELECT @assigned_hours=assigned_hours FROM Student
WHERE @studentID=student_id;

SELECT @credit_hrs=credit_hours FROM Request
WHERE @RequestID=request_id AND @studentID=student_id AND @advisorID=advisor_id;

SELECT prerequisite_course_id INTO PreqTable FROM PreqCourse_course
WHERE course_id=@courseID;

IF(@assigned_hours-@credit_hrs>=0 AND 
NOT EXISTS(
Select * from PreqTable 
EXCEPT(SELECT course_id
FROM Student_Instructor_Course_Take SCT WHERE
SCT.student_id=@studentID)
          )
)

BEGIN
UPDATE Request set status = 'approved' WHERE @RequestID = request_id;
UPDATE Student set assigned_hours=@assigned_hours-@credit_hrs;
INSERT INTO  Student_Instructor_Course_Take(student_id, course_id) VALUES(@studentID, @courseID );
END

ELSE
UPDATE Request set status = 'rejected'
WHERE @RequestID = request_id;;
GO
/*
INSERT INTO Course VALUES('CS1','eng',1,1,1); --2
INSERT INTO Course VALUES('CS2','eng',1,1,1); --3
INSERT INTO Course VALUES('C3','eng',1,1,1); --4
INSERT INTO PreqCourse_course VALUES(2,3);
INSERT INTO PreqCourse_course VALUES(3,4);
INSERT --?INTO Student_Instructor_Course_Take(student_id,) VALUES(1,null,2);
INSERT INTO Request VALUES('d','dh','pending',2,1,1,4);
*/


--Z
GO
CREATE PROC Procedures_AdvisorViewPendingRequests
@advisorID int
AS
Select R.request_id, R.type, R.comment,R.credit_hours,R.student_id,R.course_id 
FROM Request R WHERE R.status='pending' AND R.advisor_id=@advisorID;
GO
-- EXEC Procedures_AdvisorViewPendingRequests 1;
--KK
GO
CREATE PROC Procedures_StudentRegisterSecondMakeup
@StudentID int,
@courseID int,
@Student_Current_Semester Varchar (40)
AS
DECLARE @eligbit BIT,
@semesterStartD DATE,
@semesterEndD DATE,
@examID int

SELECT @semesterStartD=start_date,@semesterEndD=end_date 
FROM Semester WHERE @Student_Current_Semester=semester_code;

--SET @eligibit
IF(@eligbit=1)
BEGIN
SELECT @examID=exam_id
FROM MakeUp_Exam WHERE course_id=@courseID AND date BETWEEN @semesterStartD AND @semesterEndD;
INSERT INTO Exam_Student VALUES (@examID,@StudentID,@courseID);
END;
ELSE
print 'Can not register as not eligible';;
GO

--LL
GO
CREATE PROC Procedures_ViewRequiredCourses
@Student_ID int, @Current_semester_code Varchar (40)
AS
declare @startOfCurrent date,
@major varchar(40)

SELECT @startOfCurrent=start_date from Semester 
WHERE semester_code=@Current_semester_code;

SELECT @major=major FROM Student
WHERE student_id=@Student_ID

Select CS.course_id INTO AllCourses FROM
Course_Semester CS INNER JOIN Semester S ON
S.semester_code=CS.semester_code INNER JOIN
Course C ON C.course_id=CS.course_id
WHERE S.end_date<=@startOfCurrent AND C.major=@major

SELECT * INTO Unattended FROM
(
(Select * FROM AllCourses)
EXCEPT
(Select course_id FROM Student_Instructor_Course_Take 
WHERE student_id=@Student_ID)
)as temp


SELECT course_id INTO Failed FROM Student_Instructor_Course_Take
WHERE student_id=@Student_ID AND grade LIKE '%F%' 

SELECT *  INTO Result FROM Failed
INSERT INTO Result Select * FROM Unattended

SELECT C.* FROM Result R INNER JOIN Course C ON C.course_id=R.course_id
DROP TABLE Unattended;
DROP TABLE Failed;
DROP TABLE AllCourses;
DROP TABLE Result;;
--add here function for eligibility
GO
--exec Procedures_ViewRequiredCourses 1, 'w23'


--II
go
create proc Procedures_StudentRegisterFirstMakeup
@StudentID int, @courseID int, @studentCurrent_semester varchar(40)
as
declare @examid int, @next_semester varchar(40),@end_of_prev_semester date

SELECT end_date=@end_of_prev_semester
FROM Semester WHERE  @studentCurrent_semester=semester_code

select top 1 semester_code=@next_semester
FROM Semester 
WHERE start_date>=@end_of_prev_semester
ORDER BY start_date

select top 1 @examid = exam_id from Makeup_Exam 
where @courseID = course_id AND date>=@end_of_prev_semester AND type='First_makeup'
ORDER BY date

INSERT INTO Exam_Student VALUES(@examid , @StudentID, @courseID)
INSERT INTO Student_Instructor_Course_Take(student_id,course_id,semester_code,exam_type) VALUES(@StudentID,@courseID,@next_semester,'First_makeup');;
go

exec Procedures_StudentRegisterFirstMakeup 5, 1, '1'

-----------------------------------------------------------------



