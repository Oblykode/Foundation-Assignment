
CREATE DATABASE IF NOT EXISTS SeatingArrangement;
USE SeatingArrangement;


DROP TABLE IF EXISTS Seating;
DROP TABLE IF EXISTS Friendships;
DROP TABLE IF EXISTS Students;


CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL
);


CREATE TABLE Friendships (
    StudentID1 INT NOT NULL,
    StudentID2 INT NOT NULL,
    PRIMARY KEY (StudentID1, StudentID2),
    FOREIGN KEY (StudentID1) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (StudentID2) REFERENCES Students(StudentID) ON DELETE CASCADE,
    CHECK (StudentID1 < StudentID2)
);


CREATE TABLE Seating (
    Position INT PRIMARY KEY,
    StudentID INT NOT NULL UNIQUE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE
);


INSERT INTO Students (StudentID, StudentName, City) VALUES
(1, 'Asha', 'Kathmandu'),
(2, 'Bikash', 'Pokhara'),
(3, 'Nisha', 'Kathmandu'),
(4, 'Rohan', 'Lalitpur'),
(5, 'Suman', 'Kathmandu'),
(6, 'Pooja', 'Pokhara'),
(7, 'Aman', 'Lalitpur'),
(8, 'Kiran', 'Bhaktapur'),
(9, 'Maya', 'Pokhara'),
(10, 'Rajesh', 'Bhaktapur');


INSERT INTO Friendships (StudentID1, StudentID2) VALUES
(1, 2),   -- Asha and Bikash are friends
(1, 3),   -- Asha and Nisha are friends
(2, 6),   -- Bikash and Pooja are friends
(3, 5),   -- Nisha and Suman are friends
(4, 7),   -- Rohan and Aman are friends
(6, 9),   -- Pooja and Maya are friends
(8, 10);  -- Kiran and Rajesh are friends


INSERT INTO Seating (Position, StudentID) VALUES
(1, 1),   -- Asha (Kathmandu)
(2, 4),   -- Rohan (Lalitpur)
(3, 3),   -- Nisha (Kathmandu)
(4, 2),   -- Bikash (Pokhara)
(5, 5),   -- Suman (Kathmandu)
(6, 9),   -- Maya (Pokhara)
(7, 8),   -- Kiran (Bhaktapur)
(8, 7),   -- Aman (Lalitpur)
(9, 6),   -- Pooja (Pokhara)
(10, 10); -- Rajesh (Bhaktapur)


SELECT 
    COUNT(*) AS TotalViolations,
    SUM(CASE WHEN f.StudentID1 IS NOT NULL THEN 1 ELSE 0 END) AS FriendViolations,
    SUM(CASE WHEN s1_city.City = s2_city.City THEN 1 ELSE 0 END) AS CityViolations
FROM 
    Seating s1
    INNER JOIN Seating s2 ON s1.Position + 1 = s2.Position
    LEFT JOIN Friendships f ON (f.StudentID1 = LEAST(s1.StudentID, s2.StudentID) 
                            AND f.StudentID2 = GREATEST(s1.StudentID, s2.StudentID))
    INNER JOIN Students s1_city ON s1.StudentID = s1_city.StudentID
    INNER JOIN Students s2_city ON s2.StudentID = s2_city.StudentID;

SELECT 
    s1.Position AS Position1,
    s2.Position AS Position2,
    s1_info.StudentName AS Student1,
    s2_info.StudentName AS Student2,
    s1_info.City AS City1,
    s2_info.City AS City2,
    CASE 
        WHEN f.StudentID1 IS NOT NULL THEN 'YES' 
        ELSE 'NO' 
    END AS AreFriends,
    CASE 
        WHEN s1_info.City = s2_info.City THEN 'YES' 
        ELSE 'NO' 
    END AS SameCity,
    CASE 
        WHEN f.StudentID1 IS NOT NULL OR s1_info.City = s2_info.City THEN 'VIOLATION' 
        ELSE 'OK' 
    END AS Status
FROM 
    Seating s1
    INNER JOIN Seating s2 ON s1.Position + 1 = s2.Position
    INNER JOIN Students s1_info ON s1.StudentID = s1_info.StudentID
    INNER JOIN Students s2_info ON s2.StudentID = s2_info.StudentID
    LEFT JOIN Friendships f ON (f.StudentID1 = LEAST(s1.StudentID, s2.StudentID) 
                            AND f.StudentID2 = GREATEST(s1.StudentID, s2.StudentID))
ORDER BY s1.Position;


SELECT 
    s.Position,
    st.StudentName,
    st.City
FROM 
    Seating s
    INNER JOIN Students st ON s.StudentID = st.StudentID
ORDER BY s.Position;


SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'VALID ARRANGEMENT' 
        ELSE CONCAT('INVALID - ', COUNT(*), ' violations found') 
    END AS ValidationResult
FROM (
    SELECT 1
    FROM Seating s1
    INNER JOIN Seating s2 ON s1.Position + 1 = s2.Position
    INNER JOIN Students s1_city ON s1.StudentID = s1_city.StudentID
    INNER JOIN Students s2_city ON s2.StudentID = s2_city.StudentID
    LEFT JOIN Friendships f ON (f.StudentID1 = LEAST(s1.StudentID, s2.StudentID) 
                            AND f.StudentID2 = GREATEST(s1.StudentID, s2.StudentID))
    WHERE f.StudentID1 IS NOT NULL OR s1_city.City = s2_city.City
) AS violations;


SELECT 
    s1.StudentName AS Student1,
    s2.StudentName AS Student2
FROM 
    Friendships f
    INNER JOIN Students s1 ON f.StudentID1 = s1.StudentID
    INNER JOIN Students s2 ON f.StudentID2 = s2.StudentID
ORDER BY s1.StudentName, s2.StudentName;


SELECT 
    City,
    COUNT(*) AS StudentCount,
    GROUP_CONCAT(StudentName ORDER BY StudentName SEPARATOR ', ') AS Students
FROM Students
GROUP BY City
ORDER BY StudentCount DESC, City;

SELECT 
    s.StudentID,
    s.StudentName,
    s.City,
    COUNT(f.StudentID1) AS FriendCount
FROM 
    Students s
    LEFT JOIN Friendships f ON s.StudentID = f.StudentID1 OR s.StudentID = f.StudentID2
GROUP BY s.StudentID, s.StudentName, s.City
ORDER BY FriendCount DESC, s.StudentName;