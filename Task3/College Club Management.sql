
CREATE DATABASE IF NOT EXISTS CollegeClubManagement;
USE CollegeClubManagement;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Club;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS ClubMembership_Denormalized;


CREATE TABLE ClubMembership_Denormalized (
    StudentID INT,
    StudentName VARCHAR(100),
    Email VARCHAR(150),
    ClubName VARCHAR(100),
    ClubRoom VARCHAR(50),
    ClubMentor VARCHAR(100),
    JoinDate DATE
);


INSERT INTO ClubMembership_Denormalized (StudentID, StudentName, Email, ClubName, ClubRoom, ClubMentor, JoinDate) VALUES
(1, 'Asha', 'asha@email.com', 'Music Club', 'R101', 'Mr. Raman', '2024-01-10'),
(2, 'Bikash', 'bikash@email.com', 'Sports Club', 'R202', 'Ms. Sita', '2024-01-12'),
(1, 'Asha', 'asha@email.com', 'Sports Club', 'R202', 'Ms. Sita', '2024-01-15'),
(3, 'Nisha', 'nisha@email.com', 'Music Club', 'R101', 'Mr. Raman', '2024-01-20'),
(4, 'Rohan', 'rohan@email.com', 'Drama Club', 'R303', 'Mr. Kiran', '2024-01-18'),
(5, 'Suman', 'suman@email.com', 'Music Club', 'R101', 'Mr. Raman', '2024-01-22'),
(2, 'Bikash', 'bikash@email.com', 'Drama Club', 'R303', 'Mr. Kiran', '2024-01-25'),
(6, 'Pooja', 'pooja@email.com', 'Sports Club', 'R202', 'Ms. Sita', '2024-01-27'),
(3, 'Nisha', 'nisha@email.com', 'Coding Club', 'Lab1', 'Mr. Anil', '2024-01-28'),
(7, 'Aman', 'aman@email.com', 'Coding Club', 'Lab1', 'Mr. Anil', '2024-01-30');


CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL
);


CREATE TABLE Club (
    ClubID INT PRIMARY KEY AUTO_INCREMENT,
    ClubName VARCHAR(100) UNIQUE NOT NULL,
    ClubRoom VARCHAR(50) NOT NULL,
    ClubMentor VARCHAR(100) NOT NULL
);

CREATE TABLE Membership (
    MembershipID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    ClubID INT NOT NULL,
    JoinDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (ClubID) REFERENCES Club(ClubID) ON DELETE CASCADE,
    UNIQUE KEY unique_membership (StudentID, ClubID)
);


INSERT INTO Student (StudentID, StudentName, Email) VALUES
(1, 'Asha', 'asha@email.com'),
(2, 'Bikash', 'bikash@email.com'),
(3, 'Nisha', 'nisha@email.com'),
(4, 'Rohan', 'rohan@email.com'),
(5, 'Suman', 'suman@email.com'),
(6, 'Pooja', 'pooja@email.com'),
(7, 'Aman', 'aman@email.com');


INSERT INTO Club (ClubName, ClubRoom, ClubMentor) VALUES
('Music Club', 'R101', 'Mr. Raman'),
('Sports Club', 'R202', 'Ms. Sita'),
('Drama Club', 'R303', 'Mr. Kiran'),
('Coding Club', 'Lab1', 'Mr. Anil');


INSERT INTO Membership (StudentID, ClubID, JoinDate) VALUES
(1, 1, '2024-01-10'),  -- Asha - Music Club
(2, 2, '2024-01-12'),  -- Bikash - Sports Club
(1, 2, '2024-01-15'),  -- Asha - Sports Club
(3, 1, '2024-01-20'),  -- Nisha - Music Club
(4, 3, '2024-01-18'),  -- Rohan - Drama Club
(5, 1, '2024-01-22'),  -- Suman - Music Club
(2, 3, '2024-01-25'),  -- Bikash - Drama Club
(6, 2, '2024-01-27'),  -- Pooja - Sports Club
(3, 4, '2024-01-28'),  -- Nisha - Coding Club
(7, 4, '2024-01-30');  -- Aman - Coding Club


SELECT 
    'Data Redundancy Analysis' AS Analysis,
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT StudentID) AS UniqueStudents,
    COUNT(*) - COUNT(DISTINCT StudentID) AS DuplicateStudentRows
FROM ClubMembership_Denormalized;


SELECT 
    StudentName,
    Email,
    COUNT(*) AS TimesRepeated
FROM ClubMembership_Denormalized
GROUP BY StudentName, Email
HAVING COUNT(*) > 1
ORDER BY TimesRepeated DESC;


SELECT 
    ClubName,
    ClubRoom,
    ClubMentor,
    COUNT(*) AS TimesRepeated
FROM ClubMembership_Denormalized
GROUP BY ClubName, ClubRoom, ClubMentor
ORDER BY TimesRepeated DESC;


INSERT INTO Student (StudentID, StudentName, Email)
VALUES (8, 'Kiran Rai', 'kiran@email.com');


INSERT INTO Club (ClubName, ClubRoom, ClubMentor)
VALUES ('Photography Club', 'R405', 'Ms. Lena');


SELECT * FROM Student ORDER BY StudentName;


SELECT * FROM Club ORDER BY ClubName;


SELECT 
    s.StudentName,
    c.ClubName,
    c.ClubRoom,
    c.ClubMentor,
    m.JoinDate
FROM Membership m
INNER JOIN Student s ON m.StudentID = s.StudentID
INNER JOIN Club c ON m.ClubID = c.ClubID
ORDER BY s.StudentName, m.JoinDate;


SELECT 
    s.StudentID,
    s.StudentName,
    s.Email,
    COUNT(m.MembershipID) AS ClubCount
FROM Student s
LEFT JOIN Membership m ON s.StudentID = m.StudentID
GROUP BY s.StudentID, s.StudentName, s.Email
ORDER BY ClubCount DESC, s.StudentName;


SELECT 
    c.ClubID,
    c.ClubName,
    c.ClubRoom,
    c.ClubMentor,
    COUNT(m.MembershipID) AS MemberCount
FROM Club c
LEFT JOIN Membership m ON c.ClubID = m.ClubID
GROUP BY c.ClubID, c.ClubName, c.ClubRoom, c.ClubMentor