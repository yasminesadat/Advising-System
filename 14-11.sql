--DROP DATABASE Advising_Team_47
CREATE DATABASE Advising_Team_47

GO
USE Advising_Team_47


GO 
CREATE PROCEDURE CreateAllTables AS

CREATE TABLE Advisor(
advisor_id int PRIMARY KEY IDENTITY,
name varchar(40) NOT NULL,
email varchar(40) NOT NULL,
office varchar(40) NOT NULL,
password varchar(40) NOT NULL
);

CREATE TABLE Student(
student_id int PRIMARY KEY IDENTITY,
f_name varchar(40) NOT NULL,
l_name varchar(40) NOT NULL,
gpa decimal(3,2) NOT NULL check(gpa BETWEEN 0.7 AND 4),
faculty varchar(40) NOT NULL,
email varchar(40) NOT NULL,
major varchar(40) NOT NULL,
password varchar(40) NOT NULL,
financial_status bit,
--AS CASE WHEN CURRENT_TIMESTAMP>(Installment(deadline))
-- Installment.status=1 THEN 1 ELSE O END,
semester varchar(40) NOT NULL,
acquired_hours int NOT NULL,
assigned_hours int,
advisor_id int ,
CONSTRAINT FK_Student FOREIGN KEY(advisor_id) references Advisor(advisor_id) 
);

CREATE TABLE Course(
course_id int PRIMARY KEY IDENTITY,
name varchar(40) NOT NULL,
major varchar(40) NOT NULL,
is_offered bit NOT NULL,
credit_hours int NOT NULL,
semester int NOT NULL
);

CREATE TABLE Request(
request_id int primary key,
type varchar(40) not null,
comment varchar(40) not null,
status varchar(40) not null check(status IN ('pending','approved','rejected')) default 'pending',
credit_hours int not null,
student_id int not null,
advisor_id int not null,
course_id int not null,
CONSTRAINT FK_Request_S foreign key (student_id) references Student(student_id),
CONSTRAINT FK_Request_A foreign key (advisor_id) references Advisor(advisor_id)
);

CREATE TABLE Semester(
semester_code varchar(40) PRIMARY KEY,
start_date DATE NOT NULL, 
end_date DATE NOT NULL);

CREATE TABLE Payment(
payment_id int primary key,
amount int not null,
deadline date not null,
n_installments int not null,
status varchar(40) default 'notPaid' check (status in ('notPaid','Paid')),
fund_percentage int not null,
student_id int not null,
semester_code varchar(40) not null,
start_date date not null,
CONSTRAINT FK_Payment_S foreign key (student_id) references Student(student_id) ,
CONSTRAINT FK_Payment_SC foreign key (semester_code) references Semester(semester_code) 
);

CREATE TABLE Installment(
payment_id int ,
deadline date,
amount int not null,
status bit not null,
start_date date not null,
CONSTRAINT FK_Installment foreign key (payment_id) references Payment(payment_id) ,
primary key(payment_id,deadline)
);

--CHECK (n_installments = TIMESTAMPDIFF(MONTH, start_date, deadline)),

CREATE TABLE Student_Phone(
student_id int ,
phone_number int, 
PRIMARY KEY(student_id,phone_number),
CONSTRAINT FK_SP FOREIGN KEY(student_id) references Student(student_id)
);

CREATE TABLE Instructor(
instructor_id int PRIMARY KEY,
name varchar(40) NOT NULL,
email varchar(40) NOT NULL,
faculty varchar(40) NOT NULL,
office varchar(40) NOT NULL
);

CREATE TABLE PreqCourse_course(
prerequisite_course_id int NOT NULL,
course_id int NOT NULL,
PRIMARY KEY(prerequisite_course_id, course_id),
CONSTRAINT FK_Preq FOREIGN KEY(prerequisite_course_id) references Course(course_id),
CONSTRAINT FK_PreqC FOREIGN KEY(course_id) references Course(course_id)
);

CREATE TABLE Instructor_Course(
course_id int NOT NULL,
instructor_id int NOT NULL,
PRIMARY KEY(course_id,instructor_id),
CONSTRAINT FK_ICC FOREIGN KEY(course_id) references Course(course_id),
CONSTRAINT FK_ICI FOREIGN KEY(instructor_id) references Instructor(instructor_id)
);

CREATE TABLE Student_Instructor_Course_Take(
student_id int NOT NULL,
course_id int NOT NULL,
instructor_id int NOT NULL,
semester_code varchar(40) NOT NULL,
exam_type varchar(40) DEFAULT 'Normal' check(exam_type IN ('Normal','First_makeup','Second_makeup')),
grade decimal(4,2) check(grade BETWEEN O AND 100),  --? is it the percentage?
PRIMARY KEY(student_id,course_id,instructor_id),
CONSTRAINT FK_SIC1 FOREIGN KEY(student_id) references Student(student_id),
CONSTRAINT FK_SIC2 FOREIGN KEY(course_id) references Course(course_id),
CONSTRAINT FK_SIC3 FOREIGN KEY(instructor_id) references Instructor(instructor_id)
);

CREATE TABLE MakeUp_Exam(
exam_id int PRIMARY KEY,
date date NOT NULL,
type varchar(40) NOT NULL check(type IN ('First_makeup','Second_makeup')),
course_id int not null,
CONSTRAINT FK_MU FOREIGN KEY (course_id) references Course(course_id)
);

CREATE TABLE Exam_Student(
exam_id int not null,
student_id int not null,
course_id int NOT NULL,
PRIMARY KEY(exam_id, student_id),
CONSTRAINT FK_ES1 FOREIGN KEY (exam_id) references MakeUp_Exam(exam_id),
CONSTRAINT FK_ES2 FOREIGN KEY (student_id) references Student(student_id)
);

CREATE TABLE Graduation_Plan(
plan_id int, 
semester_code varchar(40) , 
semester_credit_hours int NOT NULL, 
expected_grad_semester int NOT NULL , 
advisor_id int NOT NULL ,
student_id int NOT NULL,
CONSTRAINT FK_GP1 FOREIGN KEY(advisor_id) references Advisor(advisor_id),
CONSTRAINT FK_GP2 FOREIGN KEY(student_id) references Student(student_id),
primary key(plan_id,semester_code)
);

CREATE TABLE GradPlan_Course(
plan_id int ,
semester_code varchar(40) , 
course_id int,
CONSTRAINT FK_GC1 FOREIGN KEY(plan_id, semester_code) REFERENCES Graduation_plan(plan_id, semester_code),
CONSTRAINT FK_GC2 FOREIGN KEY(course_id) references Course(course_id),
primary key(plan_id,semester_code,course_id)
);

CREATE TABLE Slot(
slot_id int PRIMARY KEY IDENTITY, 
day varchar(40) NOT NULL, 
time int NOT NULL , 
location VARCHAR(40) NOT NULL, 
course_id int,
instructor_id int,
CONSTRAINT FK_SC1 FOREIGN KEY (course_id) references Course(course_id) , 
CONSTRAINT FK_SC2 FOREIGN KEY (instructor_id) references Instructor(instructor_id) 
);

CREATE TABLE Course_Semester(
course_id int , 
semester_code varchar(40) ,
CONSTRAINT FK_CS1 FOREIGN KEY(course_id) references Course(course_id) , 
CONSTRAINT FK_CS2 FOREIGN KEY(semester_code) references Semester(semester_code),
primary key(semester_code, course_id)
);
GO

EXEC CreateAllTables;
----------------------------------- TEST VALUES ---------------------------------------
INSERT INTO Advisor VALUES('ahmed','hi@gmail.com','C5','cheese');
INSERT INTO Student VALUES('ali','z',2.1,'eng','@','MET','batetes',1,4,3,2,1);
INSERT INTO Course VALUES('math','eng',1,23,1);
INSERT INTO Request VALUES(5435,'a','hi','pending',13,1,1,1);
INSERT INTO Semester VALUES('1','1-11-2000','1-12-2000');
INSERT INTO Payment VALUES(4364783,46967239,'1-11-2000',1,'notPaid',50,1,'1','11-2-2000');
INSERT INTO Installment VALUES(4364783,'11-2-2000',13,0,'11-20-2000');
INSERT INTO Instructor VALUES(1,'ah','@','M','C');
INSERT INTO MakeUp_Exam VALUES(21,'11-2-2020','First_makeup',1);
INSERT INTO Graduation_Plan VALUES(1,'s23',20,1,1,1);
INSERT INTO Slot VALUES('Mon',2,'iew',1,1);
----------------------------------------------------------------------------------------

GO
CREATE PROCEDURE DropAllTables AS
ALTER TABLE Student
DROP Constraint FK_Student;
ALTER TABLE Request
DROP CONSTRAINT FK_Request_S, FK_Request_A;
ALTER TABLE Payment
DROP CONSTRAINT FK_Payment_S,FK_Payment_SC;
ALTER TABLE Installment
DROP CONSTRAINT FK_Installment;
ALTER TABLE Student_Phone
DROP CONSTRAINT FK_SP;
ALTER TABLE PreqCourse_course
DROP CONSTRAINT FK_Preq,FK_PreqC;
ALTER TABLE Instructor_Course
DROP CONSTRAINT FK_ICC,FK_ICI;
ALTER TABLE Student_Instructor_Course_Take
DROP CONSTRAINT FK_SIC1,FK_SIC2,FK_SIC3;
ALTER TABLE GradPlan_Course
DROP CONSTRAINT FK_GC1,FK_GC2;
ALTER TABLE Graduation_Plan
DROP CONSTRAINT FK_GP1,FK_GP2;
ALTER TABLE Slot
DROP CONSTRAINT FK_SC1,FK_SC2;
ALTER TABLE Course_Semester
DROP CONSTRAINT FK_CS1,FK_CS2;
DROP TABLE Advisor;
DROP TABLE Student_Phone;
DROP TABLE Request;
DROP TABLE Semester;
DROP TABLE Payment;
DROP TABLE Installment;
DROP TABLE Instructor;
DROP TABLE PreqCourse_course;
DROP TABLE Instructor_Course;
DROP TABLE Student_Instructor_Course_Take;
DROP TABLE Exam_Student;
DROP TABLE Graduation_Plan;
DROP TABLE GradPlan_Course;
DROP TABLE Slot;
DROP TABLE Course_Semester;
DROP TABLE Student;
DROP TABLE Makeup_Exam;
DROP TABLE Course;
GO

--EXEC DropAllTables
--DROP PROC DropAllTables

GO
CREATE PROCEDURE clearAllTables AS
DELETE FROM Course_Semester;
DELETE FROM Slot;
DELETE FROM GradPlan_Course;
DELETE FROM Graduation_Plan;
DELETE FROM Exam_Student;
DELETE FROM Makeup_Exam;
DELETE FROM Student_Instructor_Course_Take;
DELETE FROM Instructor_Course;
DELETE FROM PreqCourse_course;
DELETE FROM Instructor;
DELETE FROM Installment;
DELETE FROM Payment;
DELETE FROM Semester;
DELETE FROM Request;
DELETE FROM Course;
DELETE FROM Student_Phone;
DELETE FROM Student;
DELETE FROM Advisor;
GO
--EXEC clearAllTables