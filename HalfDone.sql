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

SELECT @credit_hrs=credit_hours FROM Course
WHERE @courseID=course_id;

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
INSERT INTO Student_Instructor_Course_Take(student_id,course_id) VALUES(1,1);
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


