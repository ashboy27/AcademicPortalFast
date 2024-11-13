CREATE TABLE `User` (
  `User_Id` VARCHAR(10),
  `User_Name` VARCHAR(50),
  `CNIC` VARCHAR(16),
  `Email_Id` VARCHAR(30),
  `Department` VARCHAR(4),
  `Password` VARCHAR(255),
  `Phone_Number` VARCHAR(15),
  `Address` VARCHAR(100),
  `User_Type` ENUM('Student', 'Teacher',),
  PRIMARY KEY (`User_Id`)
);

CREATE TABLE `Student` (
  `Student_Id` VARCHAR(10),
  `User_Id` VARCHAR(10),
  `Department` VARCHAR(30),
  `Batch` INT,
  PRIMARY KEY (`Student_Id`),
  CONSTRAINT `FK_Student_User_Id`
  FOREIGN KEY (`User_Id`) REFERENCES `User` (`User_Id`)
);

CREATE TABLE `Teacher` (
  `Teacher_Id` VARCHAR(10),
  `User_Id` VARCHAR(10),
  `Hire_Date` DATE,
  PRIMARY KEY (`Teacher_Id`),
  CONSTRAINT `FK_Teacher_User_Id`
  FOREIGN KEY (`User_Id`) REFERENCES `User` (`User_Id`)
);

CREATE TABLE `Course` (
  `Course_Code` VARCHAR(20),
  `Course_Name` VARCHAR(30),
  `Credit_Hrs` INT,
  `Semester` INT,
  `Prereq_Id` VARCHAR(20),
  PRIMARY KEY (`Course_Code`),
  FOREIGN KEY (`Prereq_Id`) REFERENCES `Course` (`Course_Code`)
);

CREATE TABLE `Teacher_Section_Course` (
  `Section_Id` VARCHAR(5),
  `Teacher_Id` VARCHAR(10),
  `Course_Code` VARCHAR(20),
  PRIMARY KEY (`Section_Id`, `Teacher_Id`, `Course_Code`),
  CONSTRAINT `FK_Teacher_Section_Course_Teacher_Id`
  FOREIGN KEY (`Teacher_Id`) REFERENCES `Teacher` (`Teacher_Id`),
  CONSTRAINT `FK_Teacher_Section_Course_Course_Id`
  FOREIGN KEY (`Course_Code`) REFERENCES `Course` (`Course_Code`)
);

CREATE TABLE `Enrollment` (
    `Course_Code` VARCHAR(20),
    `Student_Id` VARCHAR(10),
    `Section_Id` VARCHAR(5),
    PRIMARY KEY (`Course_Code`, `Student_Id`),
    CONSTRAINT `FK_Enrollment_Course_Code`
        FOREIGN KEY (`Course_Code`) REFERENCES `Course`(`Course_Code`),
    CONSTRAINT `FK_Enrollment_Student_Id`
        FOREIGN KEY (`Student_Id`) REFERENCES `Student`(`Student_Id`),
    CONSTRAINT `FK_Enrollment_Section_Id`
        FOREIGN KEY (`Section_Id`) REFERENCES `Teacher_Section_Course`(`Section_Id`)
);

CREATE TABLE `Announcement` (
  `Announcement_Id` VARCHAR(20),
  `Section_Id` VARCHAR(5),
  `Teacher_Id` VARCHAR(10),
  `Course_Code` VARCHAR(20),
  `Upload_time` TIME,
  `Upload_date` DATE,
  `Content` TEXT,
  PRIMARY KEY (`Announcement_Id`),
  CONSTRAINT `FK_Announcement_Section_Id`
    FOREIGN KEY (`Section_Id`) REFERENCES `Teacher_Section_Course`(`Section_Id`),
  CONSTRAINT `FK_Announcement_Teacher_Id` 
    FOREIGN KEY (`Teacher_Id`) REFERENCES `Teacher_Section_Course` (`Teacher_Id`),
  CONSTRAINT `FK_Announcement_Course_Code`
    FOREIGN KEY (`Course_Code`) REFERENCES `Teacher_Section_Course` (`Course_Code`)
);

CREATE TABLE `Assignments` (
  `Assignment_Id` VARCHAR(20),
  `Course_Code` VARCHAR(20),
  `Teacher_Id` VARCHAR(10),
  `Section_Id` VARCHAR(5),
  `Due_Date` DATE,
  `Upload_Date` DATE,
  `Upload_Time` TIME,
  `Document` BLOB,
  `Total_Marks` INT,
  PRIMARY KEY (`Assignment_Id`),
  CONSTRAINT `FK_Assignments_Section_Id`
    FOREIGN KEY (`Section_Id`) REFERENCES `Teacher_Section_Course`(`Section_Id`),
  CONSTRAINT `FK_Assignments_Teacher_Id` 
    FOREIGN KEY (`Teacher_Id`) REFERENCES `Teacher_Section_Course` (`Teacher_Id`),
  CONSTRAINT `FK_Assignments_Course_Code`
    FOREIGN KEY (`Course_Code`) REFERENCES `Teacher_Section_Course` (`Course_Code`)
);

CREATE TABLE `StudentAssignment` (
    `Course_Code` VARCHAR(20),
    `Assignment_Id` VARCHAR(20),
    `Student_Id` VARCHAR(10),
    `Submit_Date` DATE,
    `Submit_Time` TIME,
    `Document` BLOB,
    CONSTRAINT `FK_StudentAssignment_Course_Code`
        FOREIGN KEY (`Course_Code`) REFERENCES `Course`(`Course_Code`),
    CONSTRAINT `FK_StudentAssignment_Assignment_Id`
        FOREIGN KEY (`Assignment_Id`) REFERENCES `Assignments`(`Assignment_Id`),
    CONSTRAINT `FK_StudentAssignment_Student_Id`
        FOREIGN KEY (`Student_Id`) REFERENCES `Student`(`Student_Id`)
);

CREATE TABLE `ToDo_List` (
  `Assignment_Id` VARCHAR(20),
  `Status` BOOLEAN,
  CONSTRAINT `FK_ToDo_List.Assignment_Id`
  FOREIGN KEY (`Assignment_Id`) REFERENCES
  `Assignments` (`Assignment_Id`)
);

CREATE TABLE `Exam` (
  `Exam_Id` VARCHAR(20),
  `Section_Id` VARCHAR(5),
  `Exam_Title` VARCHAR(30),
  `Course_Code` VARCHAR(20),
  `Student_Id` VARCHAR(10),
  `Total_Marks` INT,
  `Obtained_Marks` INT,
  PRIMARY KEY (`Exam_Id`),
  CONSTRAINT `FK_Exam_Section_Id`
    FOREIGN KEY (`Section_Id`) REFERENCES `Teacher_Section_Course`(`Section_Id`),
  CONSTRAINT `FK_Exam_Course_Code`
    FOREIGN KEY (`Course_Code`) REFERENCES `Teacher_Section_Course` (`Course_Code`),
  CONSTRAINT `FK_Exam_Student_Id`
    FOREIGN KEY (`Student_Id`) REFERENCES `Student`(`Student_Id`)
);

CREATE TABLE `Assignment_Marks` (
  `Assignment_Id` VARCHAR(20),
  `Student_Id` VARCHAR(10),
  `Marks_Obtained` DOUBLE,
  `Grading_Date` DATETIME,
  `Feedback` TEXT,
  CONSTRAINT `FK_Assignment_Marks_Assignment_Id`
    FOREIGN KEY (`Assignment_Id`) REFERENCES `Assignments`(`Assignment_Id`),
  CONSTRAINT `FK_Assignment_Marks_Student_Id`
    FOREIGN KEY (`Student_Id`) REFERENCES `Student`(`Student_Id`)
);

CREATE TABLE `Attendance` (
  `Course_Code` VARCHAR(20),
  `Student_Id` VARCHAR(10),
  `Attend_Date` DATE,
  `Status` BOOLEAN,
  PRIMARY KEY (`Course_Code`, `Student_Id`, `Attend_Date`),
  CONSTRAINT `FK_Attendance_Course_Code`
    FOREIGN KEY (`Course_Code`) REFERENCES `Course`(`Course_Code`),
  CONSTRAINT `FK_Attendance_Student_Id`
    FOREIGN KEY (`Student_Id`) REFERENCES `Student`(`Student_Id`)
);
