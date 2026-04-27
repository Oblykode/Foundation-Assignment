##  Investigation and Analysis of Computing Data for Data Management

## Table of Contents

- [Repository Structure](#repository-structure)
- [Task 1 – Enhancing Secure Data Exchange](#task-1--enhancing-secure-data-exchange)
- [Task 2 – Student Seating Arrangement (P vs NP)](#task-2--student-seating-arrangement-p-vs-np)
- [Task 3 – College Club Membership Management](#task-3--college-club-membership-management)
- [Installation & Setup](#installation--setup)
- [References](#references)
- [Notes](#notes)



## Repository Structure

This repository contains all practical work, SQL scripts, simulations, and diagrams for the assignment. Each task is organized into a separate folder for clarity and ease of navigation.
```

├── Task1/
│   ├── FileTransferSimulation    
│   └── report.md                          
│
├── Task2/
│   ├── seating_database.sql                 
│   └── report.md                            
│
├── Task3/
│   ├── CollegeClubManagement.sql                                         
│   ├── ER_diagram.png                       
│   └── Report.md                            
│
└── README.md                                
```


## Task 1 – Enhancing Secure Data Exchange

### Objective

Explore encoding formats and secure protocols for efficient and safe data transmission in modern computing systems.

### Contents

- **Python Simulation**: HTTP file transfer implementation using Base64 encoding
- **Encoding Analysis**: Comprehensive comparison of Base64, ASCII, and URL encoding formats
- **Protocol Integration**: Discussion on HTTPS, TLS, and SMTP for secure communication
- **Visual Diagrams**: Data flow illustrations demonstrating encoding and secure protocol layers

### Key Features

 Practical demonstration of data encoding  
 Security protocol implementation  
 Real-world application scenarios  
 Performance and efficiency analysis

### Usage
```bash
# Navigate to Task 1 directory
cd Task1/

# Run the HTTP file transfer simulation
python FileTransferSimulation.py
```

### Expected Output

- Encoded data representation in Base64 format
- Simulated HTTP request/response cycle
- Security protocol handshake demonstration
- Performance metrics and analysis



## Task 2 – Student Seating Arrangement (P vs NP)

### Objective

Examine computational complexity theory through a practical classroom seating arrangement scenario with the following constraints:

1. **Friendship Constraint**: No two friends can sit adjacent to each other
2. **City Constraint**: No two students from the same city can sit adjacent to each other

### Contents

- **`seating_database.sql`**: Complete database schema for students, friendships, cities, and seating arrangements
- **Verification Query**: SQL query to check for constraint violations in O(n) time
- **`seating_solver.py`**: Optional Python heuristic solver using backtracking and greedy algorithms

### Theoretical Foundation

This task illustrates the **P vs NP** distinction:
- **Verification** (P): Checking a solution runs in polynomial time O(n)
- **Finding** (NP): Generating a valid solution requires exponential search O(n!)

### Usage

**Step 1: Database Setup**
```bash
# Load the SQL file in MySQL
mysql -u root -p < Task2/Database setup.sql

# Or use MySQL Workbench to execute the script
```

**Step 2: Run Verification Query**
```sql
-- Execute the verification query from Database setup.sql
-- Returns violation count (0 = valid arrangement)
```


### Key Queries Included

- Main validation query (counts violations)
- Detailed violation report (shows problem pairs)
- Current seating display
- Student friendship analysis
- City distribution statistics



## Task 3 – College Club Membership Management

### Objective

Design and implement a normalized relational database for managing student club memberships, demonstrating proper database normalization techniques up to Third Normal Form (3NF).

### Contents

- **`club_database.sql`**: Complete database schema with normalized tables (Student, Club, Membership)
- **`queries.sql`**: Comprehensive SQL operations including INSERT, SELECT, UPDATE, DELETE, and JOIN
- **`ER_diagram.png`**: Entity-Relationship diagram illustrating the normalized database structure

### Database Schema

**Student Table**
- StudentID (Primary Key)
- StudentName
- Email (Unique)

**Club Table**
- ClubID (Primary Key)
- ClubName (Unique)
- ClubRoom
- ClubMentor

**Membership Table** (Junction Table)
- MembershipID (Primary Key)
- StudentID (Foreign Key → Student)
- ClubID (Foreign Key → Club)
- JoinDate

### Normalization Benefits

 **Eliminates redundancy** – Each fact stored once  
 **Prevents anomalies** – No insert/update/delete issues  
 **Ensures integrity** – Foreign key constraints  
 **Improves scalability** – Easy to extend and maintain

### Usage

**Step 1: Create Database**
```bash
# Load database schema
mysql -u root -p < Task3/College Club Management.sql
```

**Step 2: Run Sample Queries**
```bash
# Execute queries from queries.sql
mysql -u root -p CollegeClubManagement < Task3/queries.sql
```

**Step 3: Test Operations**
```sql
-- Insert new student
INSERT INTO Student (StudentID, StudentName, Email)
VALUES (8, 'Kiran Rai', 'kiran@email.com');

-- Insert new club (no insert anomaly)
INSERT INTO Club (ClubName, ClubRoom, ClubMentor)
VALUES ('Photography Club', 'R405', 'Ms. Lena');

-- Retrieve all memberships with JOIN
SELECT s.StudentName, c.ClubName, c.ClubMentor, m.JoinDate
FROM Membership m
INNER JOIN Student s ON m.StudentID = s.StudentID
INNER JOIN Club c ON m.ClubID = c.ClubID
ORDER BY s.StudentName;
```

### Sample Queries Provided

- Student and club listing
- Membership reports with JOIN operations
- Club popularity analysis
- Student activity tracking
- Redundancy comparison (normalized vs denormalized)
- Anomaly prevention demonstrations



## Installation & Setup

### Prerequisites

- **Python**: Version 3.10 or higher
- **MySQL**: Version 8.0 or higher (or MariaDB 10.5+)
- **MySQL Workbench**: Optional, for GUI-based database management

### Python Dependencies

All Python scripts use **standard libraries only**. No external packages required.
```bash
# Verify Python version
python --version

# Should output: Python 3.10.x or higher
```

### MySQL Setup
```bash
# Start MySQL service (Linux/Mac)
sudo systemctl start mysql

# Or on Windows
net start MySQL80

# Login to MySQL
mysql -u root -p
```

### Running the Scripts

1. **Clone the repository**
```bash
   git clone <repository-url>
   cd assignment-repo
```

2. **Execute Task 1**
```bash
   python Task1/http_file_transfer_simulation.py
```

3. **Load Task 2 Database**
```bash
   mysql -u root -p < Task2/seating_database.sql
```

4. **Load Task 3 Database**
```bash
   mysql -u root -p < Task3/club_database.sql
```



## References

### Academic Sources

1. **Cormen, T. H., Leiserson, C. E., Rivest, R. L., & Stein, C.** (2009). *Introduction to Algorithms* (3rd ed.). MIT Press.

2. **Codd, E. F.** (1970). "A Relational Model of Data for Large Shared Data Banks." *Communications of the ACM*, 13(6), 377-387.

3. **Stallings, W.** (2017). *Cryptography and Network Security: Principles and Practice* (7th ed.). Pearson.

4. **Garey, M. R., & Johnson, D. S.** (1979). *Computers and Intractability: A Guide to the Theory of NP-Completeness*. W.H. Freeman.

### Technical Documentation

5. **NIST** (2023). *Cybersecurity and Privacy Framework*. Retrieved from https://www.nist.gov/cybersecurity-and-privacy

6. **MySQL Documentation** (2024). *CREATE DATABASE Statement*. Retrieved from https://dev.mysql.com/doc/

7. **RFC 4648** (2006). *The Base16, Base32, and Base64 Data Encodings*. Internet Engineering Task Force (IETF).

8. **RFC 8446** (2018). *The Transport Layer Security (TLS) Protocol Version 1.3*. IETF.



## Notes

### Important Reminders

**Database Creation**: Ensure that databases for Task 2 (`SeatingArrangement`) and Task 3 (`CollegeClubManagement`) are created before running any table creation or INSERT statements.

**Python Compatibility**: All Python scripts are compatible with Python 3.10+ and require standard libraries only (no pip installations needed).

**Normalization**: ER diagrams and SQL schemas reflect normalization to **Third Normal Form (3NF)**, reducing redundancy and ensuring data integrity through proper functional dependencies.

**Foreign Key Constraints**: All tables use `ON DELETE CASCADE` to maintain referential integrity.

### Troubleshooting

**Issue**: MySQL connection errors  
**Solution**: Verify MySQL service is running and credentials are correct

**Issue**: Python script not found  
**Solution**: Ensure you're in the correct directory before running scripts

**Issue**: Foreign key constraint errors  
**Solution**: Load tables in correct order (parent tables before child tables)



## Academic Integrity Statement

This assignment represents my original work completed in accordance with academic integrity policies. All external sources, code snippets, and references have been properly cited. The implementations demonstrate understanding of fundamental computer science concepts including computational complexity, database normalization, and secure data transmission.


## License

This academic work is submitted for educational purposes only. Unauthorized reproduction or distribution is prohibited.

© 2026 Anil Tamang. All rights reserved.
