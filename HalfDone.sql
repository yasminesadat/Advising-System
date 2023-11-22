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

------------------------------------------
create function dbo.FN_StudentViewSlot
(
    @courseID int, @instructorID int

)
RETURNS @Result table (slotID int, location varchar(40), time varchar(40),day varchar(40),course_name varchar(40), instructor_name varchar(40))
AS
Begin
declare @course_name varchar(40)
declare @instructor_name varchar(40)

select @course_name=name from Course where @courseID=course_id
select @instructor_name=name from Instructor where @instructorID=instructor_id

insert into @Result(slotID,location,time,day) select slot_id,day,time,location from Slot where course_id=@courseID and instructor_id=@instructorID
insert into @Result(course_name) select name from Course where @courseID=course_id
insert into @Result(instructor_name) select name from Instructor where @instructorID=instructor_id



return
end
go

select * from dbo.FN_StudentViewSlot(1,1)

select * from Course
select * from Instructor
select * from Slot
insert into Slot values('13','15','Yes',1,1)

------------------------------------------
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
declare @examid int, @type varchar(40)

select @examid = exam_id from Makeup_Exam 
where @courseID = course_id 

select @type=type from MakeUp_Exam where @courseID=course_id    
if @type='First_makeup'
begin
insert into Exam_Student values(@examid , @StudentID, @courseID)
update Student_Instructor_Course_Take set exam_type='First_makeup'
where student_id=@StudentID and course_id=@courseID and @studentCurrent_semester=semester_code
end
go

exec Procedures_StudentRegisterFirstMakeup 5, 1, '1'

-----------------------------------------------------------------



