Last login: Sun Oct 25 19:00:14 on ttys010
(base) anthonyrestivo@Anthonys-MacBook-Air-7 ~ % /usr/local/mysql/bin/mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.4.11 MySQL Community Server - GPL

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE employee_scheduling;
Query OK, 1 row affected (0.00 sec)

mysql> USE employee_scheduling;
Database changed
mysql> SELECT DATABASE();
+---------------------+
| DATABASE()          |
+---------------------+
| employee_scheduling |
+---------------------+
1 row in set (0.00 sec)

mysql> CREATE TABLE Department (
    ->     DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    ->     DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    ->     DepartmentStatus VARCHAR(20) NOT NULL DEFAULT 'Active'
    -> );
Query OK, 0 rows affected (0.16 sec)

mysql> CREATE TABLE Employee (
    ->     EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    ->     FirstName VARCHAR(50) NOT NULL,
    ->     LastName VARCHAR(50) NOT NULL,
    ->     Email VARCHAR(100) NOT NULL UNIQUE,
    ->     DepartmentID INT NOT NULL,
    ->     HireDate DATE,
    ->     HourlyRate DECIMAL(8,2) NOT NULL,
    ->     EmployeeStatus VARCHAR(20) NOT NULL DEFAULT 'Active',
    ->     FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE TABLE Availability (
    ->     AvailabilityID INT AUTO_INCREMENT PRIMARY KEY,
    ->     EmployeeID INT NOT NULL,
    ->     DayOfWeek VARCHAR(10) NOT NULL,
    ->     StartTime TIME NOT NULL,
    ->     EndTime TIME NOT NULL,
    ->     EffectiveStartDate DATE,
    ->     EffectiveEndDate DATE,
    ->     FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE Shift (
    ->     ShiftID INT AUTO_INCREMENT PRIMARY KEY,
    ->     DepartmentID INT NOT NULL,
    ->     ShiftDate DATE NOT NULL,
    ->     StartTime TIME NOT NULL,
    ->     EndTime TIME NOT NULL,
    ->     ShiftType VARCHAR(30),
    ->     ShiftStatus VARCHAR(20) NOT NULL DEFAULT 'Open',
    ->     RequiredEmployees INT NOT NULL DEFAULT 1,
    ->     FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql> CREATE TABLE ShiftAssignment (
    ->     AssignmentID INT AUTO_INCREMENT PRIMARY KEY,
    ->     ShiftID INT NOT NULL,
    ->     EmployeeID INT NOT NULL,
    ->     AssignedDate DATE NOT NULL,
    ->     AssignmentStatus VARCHAR(20) NOT NULL DEFAULT 'Assigned',
    ->     FOREIGN KEY (ShiftID) REFERENCES Shift(ShiftID),
    ->     FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    ->     UNIQUE (ShiftID, EmployeeID)
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> CREATE TABLE TimeRecord (
    ->     TimeRecordID INT AUTO_INCREMENT PRIMARY KEY,
    ->     AssignmentID INT NOT NULL,
    ->     ClockIn DATETIME,
    ->     ClockOut DATETIME,
    ->     BreakMinutes INT NOT NULL DEFAULT 0,
    ->     LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ->         ON UPDATE CURRENT_TIMESTAMP,
    ->     FOREIGN KEY (AssignmentID) REFERENCES ShiftAssignment(AssignmentID),
    ->     CHECK (BreakMinutes >= 0),
    ->     CHECK (ClockOut IS NULL OR ClockIn IS NULL OR ClockOut >= ClockIn)
    -> );
Query OK, 0 rows affected (0.14 sec)

mysql> INSERT INTO Department (DepartmentName, DepartmentStatus)
    -> VALUES
    ->     ('Sales', 'Active'),
    ->     ('Inventory', 'Active'),
    ->     ('Customer Service', 'Active'),
    ->     ('Warehouse', 'Active'),
    ->     ('Administration', 'Active');
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW TABLES;
+-------------------------------+
| Tables_in_employee_scheduling |
+-------------------------------+
| Availability                  |
| Department                    |
| Employee                      |
| Shift                         |
| ShiftAssignment               |
| TimeRecord                    |
+-------------------------------+
6 rows in set (0.05 sec)

mysql> INSERT INTO Employee
    -> (FirstName, LastName, Email, DepartmentID, HireDate, HourlyRate, EmployeeStatus)
    -> VALUES
    -> ('Kieran', 'Ashford', 'kieran.ashford@example.com', 1, '2025-01-15', 22.00, 'Active'),
    -> ('Zaria', 'Whitlock', 'zaria.whitlock@example.com', 1, '2025-03-10', 24.00, 'Active'),
    -> ('Darius', 'Kensington', 'darius.kensington@example.com', 2, '2024-11-05', 21.00, 'Active'),
    -> ('Amara', 'Voss', 'amara.voss@example.com', 3, '2025-06-20', 20.00, 'Active'),
    -> ('Cassian', 'Thorne', 'cassian.thorne@example.com', 4, '2024-08-12', 23.00, 'Active'),
    -> ('Sienna', 'Blackwell', 'sienna.blackwell@example.com', 4, '2025-02-01', 19.50, 'Active'),
    -> ('Ronan', 'Vale', 'ronan.vale@example.com', 5, '2023-09-18', 25.00, 'Active'),
    -> ('Nyla', 'Sterling', 'nyla.sterling@example.com', 2, '2025-07-07', 20.50, 'Active');
Query OK, 8 rows affected (0.03 sec)
Records: 8  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Availability
    -> (EmployeeID, DayOfWeek, StartTime, EndTime, EffectiveStartDate, EffectiveEndDate)
    -> VALUES
    -> (1, 'Monday', '09:00:00', '17:00:00', '2026-10-01', '2026-12-31'),
    -> (2, 'Tuesday', '10:00:00', '18:00:00', '2026-10-01', '2026-12-31'),
    -> (3, 'Wednesday', '07:00:00', '15:00:00', '2026-10-01', '2026-12-31'),
    -> (4, 'Thursday', '09:00:00', '17:00:00', '2026-10-01', '2026-12-31'),
    -> (5, 'Friday', '08:00:00', '16:00:00', '2026-10-01', '2026-12-31'),
    -> (6, 'Saturday', '10:00:00', '18:00:00', '2026-10-01', '2026-12-31'),
    -> (7, 'Monday', '08:00:00', '16:00:00', '2026-10-01', '2026-12-31'),
    -> (8, 'Wednesday', '11:00:00', '19:00:00', '2026-10-01', '2026-12-31');
Query OK, 8 rows affected (0.01 sec)
Records: 8  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM Availability;
+----------------+------------+-----------+-----------+----------+--------------------+------------------+
| AvailabilityID | EmployeeID | DayOfWeek | StartTime | EndTime  | EffectiveStartDate | EffectiveEndDate |
+----------------+------------+-----------+-----------+----------+--------------------+------------------+
|              1 |          1 | Monday    | 09:00:00  | 17:00:00 | 2026-10-01         | 2026-12-31       |
|              2 |          2 | Tuesday   | 10:00:00  | 18:00:00 | 2026-10-01         | 2026-12-31       |
|              3 |          3 | Wednesday | 07:00:00  | 15:00:00 | 2026-10-01         | 2026-12-31       |
|              4 |          4 | Thursday  | 09:00:00  | 17:00:00 | 2026-10-01         | 2026-12-31       |
|              5 |          5 | Friday    | 08:00:00  | 16:00:00 | 2026-10-01         | 2026-12-31       |
|              6 |          6 | Saturday  | 10:00:00  | 18:00:00 | 2026-10-01         | 2026-12-31       |
|              7 |          7 | Monday    | 08:00:00  | 16:00:00 | 2026-10-01         | 2026-12-31       |
|              8 |          8 | Wednesday | 11:00:00  | 19:00:00 | 2026-10-01         | 2026-12-31       |
+----------------+------------+-----------+-----------+----------+--------------------+------------------+
8 rows in set (0.01 sec)

mysql> INSERT INTO Shift
    -> (DepartmentID, ShiftDate, StartTime, EndTime, ShiftType, ShiftStatus, RequiredEmployees)
    -> VALUES
    -> (1, '2026-10-26', '09:00:00', '17:00:00', 'Morning', 'Scheduled', 2),
    -> (2, '2026-10-27', '08:00:00', '16:00:00', 'Morning', 'Scheduled', 2),
    -> (3, '2026-10-28', '10:00:00', '18:00:00', 'Day', 'Scheduled', 1),
    -> (4, '2026-10-30', '07:00:00', '15:00:00', 'Morning', 'Scheduled', 2);
Query OK, 4 rows affected (0.02 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM Shift;
+---------+--------------+------------+-----------+----------+-----------+-------------+-------------------+
| ShiftID | DepartmentID | ShiftDate  | StartTime | EndTime  | ShiftType | ShiftStatus | RequiredEmployees |
+---------+--------------+------------+-----------+----------+-----------+-------------+-------------------+
|       1 |            1 | 2026-10-26 | 09:00:00  | 17:00:00 | Morning   | Scheduled   |                 2 |
|       2 |            2 | 2026-10-27 | 08:00:00  | 16:00:00 | Morning   | Scheduled   |                 2 |
|       3 |            3 | 2026-10-28 | 10:00:00  | 18:00:00 | Day       | Scheduled   |                 1 |
|       4 |            4 | 2026-10-30 | 07:00:00  | 15:00:00 | Morning   | Scheduled   |                 2 |
+---------+--------------+------------+-----------+----------+-----------+-------------+-------------------+
4 rows in set (0.01 sec)

mysql> INSERT INTO ShiftAssignment
    -> (ShiftID, EmployeeID, AssignedDate, AssignmentStatus)
    -> VALUES
    -> (1, 1, '2026-10-25', 'Assigned'),
    -> (1, 2, '2026-10-25', 'Assigned'),
    -> (2, 3, '2026-10-25', 'Assigned'),
    -> (2, 8, '2026-10-25', 'Assigned'),
    -> (3, 4, '2026-10-25', 'Assigned'),
    -> (4, 5, '2026-10-25', 'Assigned'),
    -> (4, 6, '2026-10-25', 'Assigned');
Query OK, 7 rows affected (0.03 sec)
Records: 7  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM ShiftAssignment;
+--------------+---------+------------+--------------+------------------+
| AssignmentID | ShiftID | EmployeeID | AssignedDate | AssignmentStatus |
+--------------+---------+------------+--------------+------------------+
|            1 |       1 |          1 | 2026-10-25   | Assigned         |
|            2 |       1 |          2 | 2026-10-25   | Assigned         |
|            3 |       2 |          3 | 2026-10-25   | Assigned         |
|            4 |       2 |          8 | 2026-10-25   | Assigned         |
|            5 |       3 |          4 | 2026-10-25   | Assigned         |
|            6 |       4 |          5 | 2026-10-25   | Assigned         |
|            7 |       4 |          6 | 2026-10-25   | Assigned         |
+--------------+---------+------------+--------------+------------------+
7 rows in set (0.01 sec)

mysql> INSERT INTO TimeRecord
    -> (AssignmentID, ClockIn, ClockOut, BreakMinutes)
    -> VALUES
    -> (1, '2026-10-26 09:02:00', '2026-10-26 17:00:00', 30),
    -> (2, '2026-10-26 08:55:00', '2026-10-26 17:10:00', 30),
    -> (3, '2026-10-27 08:00:00', '2026-10-27 16:05:00', 30),
    -> (4, '2026-10-27 08:12:00', '2026-10-27 16:00:00', 30),
    -> (5, '2026-10-28 10:00:00', '2026-10-28 18:15:00', 30),
    -> (6, '2026-10-30 07:00:00', '2026-10-30 15:00:00', 30),
    -> (7, '2026-10-30 07:08:00', '2026-10-30 15:12:00', 30);
Query OK, 7 rows affected (0.01 sec)
Records: 7  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM TimeRecord;
+--------------+--------------+---------------------+---------------------+--------------+---------------------+
| TimeRecordID | AssignmentID | ClockIn             | ClockOut            | BreakMinutes | LastUpdated         |
+--------------+--------------+---------------------+---------------------+--------------+---------------------+
|            1 |            1 | 2026-10-26 09:02:00 | 2026-10-26 17:00:00 |           30 | 2026-10-25 19:17:51 |
|            2 |            2 | 2026-10-26 08:55:00 | 2026-10-26 17:10:00 |           30 | 2026-10-25 19:17:51 |
|            3 |            3 | 2026-10-27 08:00:00 | 2026-10-27 16:05:00 |           30 | 2026-10-25 19:17:51 |
|            4 |            4 | 2026-10-27 08:12:00 | 2026-10-27 16:00:00 |           30 | 2026-10-25 19:17:51 |
|            5 |            5 | 2026-10-28 10:00:00 | 2026-10-28 18:15:00 |           30 | 2026-10-25 19:17:51 |
|            6 |            6 | 2026-10-30 07:00:00 | 2026-10-30 15:00:00 |           30 | 2026-10-25 19:17:51 |
|            7 |            7 | 2026-10-30 07:08:00 | 2026-10-30 15:12:00 |           30 | 2026-10-25 19:17:51 |
+--------------+--------------+---------------------+---------------------+--------------+---------------------+
7 rows in set (0.00 sec)

mysql> SELECT
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     e.HourlyRate,
    ->     ROUND(
    ->         TIMESTAMPDIFF(MINUTE, t.ClockIn, t.ClockOut) / 60.0
    ->         - t.BreakMinutes / 60.0,
    ->         2
    ->     ) AS ActualHoursWorked,
    ->     ROUND(
    ->         (
    ->             TIMESTAMPDIFF(MINUTE, t.ClockIn, t.ClockOut) / 60.0
    ->             - t.BreakMinutes / 60.0
    ->         ) * e.HourlyRate,
    ->         2
    ->     ) AS LaborCost
    -> FROM Employee e
    -> JOIN ShiftAssignment sa
    ->     ON e.EmployeeID = sa.EmployeeID
    -> JOIN TimeRecord t
    ->     ON sa.AssignmentID = t.AssignmentID
    -> ORDER BY e.EmployeeID;
+------------+-----------+------------+------------+-------------------+-----------+
| EmployeeID | FirstName | LastName   | HourlyRate | ActualHoursWorked | LaborCost |
+------------+-----------+------------+------------+-------------------+-----------+
|          1 | Kieran    | Ashford    |      22.00 |              7.47 |    164.27 |
|          2 | Zaria     | Whitlock   |      24.00 |              7.75 |    186.00 |
|          3 | Darius    | Kensington |      21.00 |              7.58 |    159.25 |
|          4 | Amara     | Voss       |      20.00 |              7.75 |    155.00 |
|          5 | Cassian   | Thorne     |      23.00 |              7.50 |    172.50 |
|          6 | Sienna    | Blackwell  |      19.50 |              7.57 |    147.55 |
|          8 | Nyla      | Sterling   |      20.50 |              7.30 |    149.65 |
+------------+-----------+------------+------------+-------------------+-----------+
7 rows in set (0.01 sec)

mysql> SELECT
    ->     d.DepartmentName,
    ->     YEARWEEK(s.ShiftDate, 1) AS WeekNumber,
    ->     SUM(
    ->         TIMESTAMPDIFF(MINUTE, s.StartTime, s.EndTime) / 60.0
    ->     ) AS TotalScheduledHours
    -> FROM Department d
    -> JOIN Shift s
    ->     ON d.DepartmentID = s.DepartmentID
    -> JOIN ShiftAssignment sa
    ->     ON s.ShiftID = sa.ShiftID
    -> GROUP BY
    ->     d.DepartmentName,
    ->     YEARWEEK(s.ShiftDate, 1)
    -> ORDER BY
    ->     WeekNumber,
    ->     d.DepartmentName;
+------------------+------------+---------------------+
| DepartmentName   | WeekNumber | TotalScheduledHours |
+------------------+------------+---------------------+
| Customer Service |     202644 |              8.0000 |
| Inventory        |     202644 |             16.0000 |
| Sales            |     202644 |             16.0000 |
| Warehouse        |     202644 |             16.0000 |
+------------------+------------+---------------------+
4 rows in set (0.06 sec)

mysql> SELECT
    ->     s.ShiftID,
    ->     d.DepartmentName,
    ->     s.ShiftDate,
    ->     s.StartTime,
    ->     s.EndTime,
    ->     COUNT(sa.EmployeeID) AS EmployeesAssigned,
    ->     ROUND(SUM(TIMESTAMPDIFF(MINUTE, s.StartTime, s.EndTime) / 60.0 * e.HourlyRate), 2) AS EstimatedLaborCost
    -> FROM Shift s
    -> JOIN Department d ON s.DepartmentID = d.DepartmentID
    -> JOIN ShiftAssignment sa ON s.ShiftID = sa.ShiftID
    -> JOIN Employee e ON sa.EmployeeID = e.EmployeeID
    -> GROUP BY
    ->     s.ShiftID,
    ->     d.DepartmentName,
    ->     s.ShiftDate,
    ->     s.StartTime,
    ->     s.EndTime
    -> ORDER BY s.ShiftDate, s.StartTime;
+---------+------------------+------------+-----------+----------+-------------------+--------------------+
| ShiftID | DepartmentName   | ShiftDate  | StartTime | EndTime  | EmployeesAssigned | EstimatedLaborCost |
+---------+------------------+------------+-----------+----------+-------------------+--------------------+
|       1 | Sales            | 2026-10-26 | 09:00:00  | 17:00:00 |                 2 |             368.00 |
|       2 | Inventory        | 2026-10-27 | 08:00:00  | 16:00:00 |                 2 |             332.00 |
|       3 | Customer Service | 2026-10-28 | 10:00:00  | 18:00:00 |                 1 |             160.00 |
|       4 | Warehouse        | 2026-10-30 | 07:00:00  | 15:00:00 |                 2 |             340.00 |
+---------+------------------+------------+-----------+----------+-------------------+--------------------+
4 rows in set (0.08 sec)

mysql> SELECT
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     SUM(TIMESTAMPDIFF(MINUTE, s.StartTime, s.EndTime)) / 60.0 AS WeeklyHours
    -> FROM Employee e
    -> JOIN ShiftAssignment sa ON e.EmployeeID = sa.EmployeeID
    -> JOIN Shift s ON sa.ShiftID = s.ShiftID
    -> GROUP BY
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     YEAR(s.ShiftDate),
    ->     WEEK(s.ShiftDate, 3)
    -> HAVING SUM(TIMESTAMPDIFF(MINUTE, s.StartTime, s.EndTime)) / 60.0 > 40;
Empty set (0.01 sec)

mysql> SELECT
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     SUM(TIMESTAMPDIFF(MINUTE, s.StartTime, s.EndTime)) / 60.0 AS ScheduledHours,
    ->     SUM(TIMESTAMPDIFF(MINUTE, tr.ClockIn, tr.ClockOut) - tr.BreakMinutes) / 60.0 AS ActualHours
    -> FROM Employee e
    -> JOIN ShiftAssignment sa ON e.EmployeeID = sa.EmployeeID
    -> JOIN Shift s ON sa.ShiftID = s.ShiftID
    -> JOIN TimeRecord tr ON sa.AssignmentID = tr.AssignmentID
    -> GROUP BY e.EmployeeID, e.FirstName, e.LastName
    -> ORDER BY e.EmployeeID;
+------------+-----------+------------+----------------+-------------+
| EmployeeID | FirstName | LastName   | ScheduledHours | ActualHours |
+------------+-----------+------------+----------------+-------------+
|          1 | Kieran    | Ashford    |         8.0000 |      7.4667 |
|          2 | Zaria     | Whitlock   |         8.0000 |      7.7500 |
|          3 | Darius    | Kensington |         8.0000 |      7.5833 |
|          4 | Amara     | Voss       |         8.0000 |      7.7500 |
|          5 | Cassian   | Thorne     |         8.0000 |      7.5000 |
|          6 | Sienna    | Blackwell  |         8.0000 |      7.5667 |
|          8 | Nyla      | Sterling   |         8.0000 |      7.3000 |
+------------+-----------+------------+----------------+-------------+
7 rows in set (0.01 sec)

mysql> SELECT
    ->     s.ShiftID,
    ->     d.DepartmentName,
    ->     s.ShiftDate,
    ->     s.StartTime,
    ->     s.EndTime
    -> FROM Shift s
    -> JOIN Department d ON s.DepartmentID = d.DepartmentID
    -> LEFT JOIN ShiftAssignment sa ON s.ShiftID = sa.ShiftID
    -> WHERE sa.AssignmentID IS NULL
    -> ORDER BY s.ShiftDate, s.StartTime;
Empty set (0.01 sec)

mysql> SELECT
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     s.ShiftDate,
    ->     COUNT(s.ShiftID) AS NumberOfShifts
    -> FROM Employee e
    -> JOIN ShiftAssignment sa ON e.EmployeeID = sa.EmployeeID
    -> JOIN Shift s ON sa.ShiftID = s.ShiftID
    -> GROUP BY
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     s.ShiftDate
    -> HAVING COUNT(s.ShiftID) > 1
    -> ORDER BY s.ShiftDate, e.EmployeeID;
Empty set (0.01 sec)

mysql> SELECT
    ->     d.DepartmentID,
    ->     d.DepartmentName,
    ->     COUNT(sa.AssignmentID) AS TotalAssignments
    -> FROM Department d
    -> JOIN Shift s ON d.DepartmentID = s.DepartmentID
    -> JOIN ShiftAssignment sa ON s.ShiftID = sa.ShiftID
    -> GROUP BY d.DepartmentID, d.DepartmentName
    -> HAVING COUNT(sa.AssignmentID) > (
    ->     SELECT AVG(DepartmentAssignments)
    ->     FROM (
    ->         SELECT COUNT(sa2.AssignmentID) AS DepartmentAssignments
    ->         FROM Department d2
    ->         JOIN Shift s2 ON d2.DepartmentID = s2.DepartmentID
    ->         JOIN ShiftAssignment sa2 ON s2.ShiftID = sa2.ShiftID
    ->         GROUP BY d2.DepartmentID
    ->     ) AS DepartmentTotals
    -> );
+--------------+----------------+------------------+
| DepartmentID | DepartmentName | TotalAssignments |
+--------------+----------------+------------------+
|            1 | Sales          |                2 |
|            2 | Inventory      |                2 |
|            4 | Warehouse      |                2 |
+--------------+----------------+------------------+
3 rows in set (0.03 sec)

mysql> SELECT
    ->     TimeRecordID,
    ->     AssignmentID,
    ->     ClockIn,
    ->     ClockOut,
    ->     BreakMinutes
    -> FROM TimeRecord
    -> WHERE ClockIn IS NULL
    ->    OR ClockOut IS NULL
    ->    OR ClockOut < ClockIn;
Empty set (0.01 sec)

mysql> SELECT
    ->     d.DepartmentName,
    ->     COUNT(DISTINCT s.ShiftID) AS TotalShifts,
    ->     COUNT(sa.AssignmentID) AS TotalAssignments,
    ->     ROUND(SUM(TIMESTAMPDIFF(MINUTE, s.StartTime, s.EndTime)) / 60.0, 2) AS TotalScheduledHours,
    ->     ROUND(SUM(
    ->         TIMESTAMPDIFF(MINUTE, s.StartTime, s.EndTime) / 60.0 * e.HourlyRate
    ->     ), 2) AS EstimatedLaborCost
    -> FROM Department d
    -> JOIN Shift s ON d.DepartmentID = s.DepartmentID
    -> JOIN ShiftAssignment sa ON s.ShiftID = sa.ShiftID
    -> JOIN Employee e ON sa.EmployeeID = e.EmployeeID
    -> GROUP BY d.DepartmentID, d.DepartmentName
    -> ORDER BY EstimatedLaborCost DESC;
+------------------+-------------+------------------+---------------------+--------------------+
| DepartmentName   | TotalShifts | TotalAssignments | TotalScheduledHours | EstimatedLaborCost |
+------------------+-------------+------------------+---------------------+--------------------+
| Sales            |           1 |                2 |               16.00 |             368.00 |
| Warehouse        |           1 |                2 |               16.00 |             340.00 |
| Inventory        |           1 |                2 |               16.00 |             332.00 |
| Customer Service |           1 |                1 |                8.00 |             160.00 |
+------------------+-------------+------------------+---------------------+--------------------+
4 rows in set (0.00 sec)

mysql> DESCRIBE Availability;
+--------------------+-------------+------+-----+---------+----------------+
| Field              | Type        | Null | Key | Default | Extra          |
+--------------------+-------------+------+-----+---------+----------------+
| AvailabilityID     | int         | NO   | PRI | NULL    | auto_increment |
| EmployeeID         | int         | NO   | MUL | NULL    |                |
| DayOfWeek          | varchar(10) | NO   |     | NULL    |                |
| StartTime          | time        | NO   |     | NULL    |                |
| EndTime            | time        | NO   |     | NULL    |                |
| EffectiveStartDate | date        | YES  |     | NULL    |                |
| EffectiveEndDate   | date        | YES  |     | NULL    |                |
+--------------------+-------------+------+-----+---------+----------------+
7 rows in set (0.07 sec)

mysql> SELECT
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     a.DayOfWeek,
    ->     a.StartTime,
    ->     a.EndTime,
    ->     a.EffectiveStartDate,
    ->     a.EffectiveEndDate
    -> FROM Employee e
    -> JOIN Availability a ON e.EmployeeID = a.EmployeeID
    -> WHERE a.EffectiveEndDate < CURDATE()
    -> ORDER BY a.EffectiveEndDate;
Empty set (0.05 sec)

mysql> SELECT
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     a.DayOfWeek,
    ->     a.StartTime,
    ->     a.EndTime,
    ->     a.EffectiveStartDate
    -> FROM Employee e
    -> JOIN Availability a ON e.EmployeeID = a.EmployeeID
    -> WHERE a.EffectiveStartDate > CURDATE()
    -> ORDER BY a.EffectiveStartDate;
Empty set (0.00 sec)

mysql> SELECT
    ->     e.EmployeeID,
    ->     e.FirstName,
    ->     e.LastName,
    ->     d.DepartmentName
    -> FROM Employee e
    -> JOIN Department d ON e.DepartmentID = d.DepartmentID
    -> LEFT JOIN Availability a ON e.EmployeeID = a.EmployeeID
    -> WHERE a.AvailabilityID IS NULL
    -> ORDER BY e.EmployeeID;
Empty set (0.01 sec)

mysql> SELECT
    ->     s.ShiftID,
    ->     d.DepartmentName,
    ->     s.ShiftDate,
    ->     s.RequiredEmployees,
    ->     COUNT(sa.AssignmentID) AS AssignedEmployees,
    ->     s.RequiredEmployees - COUNT(sa.AssignmentID) AS EmployeesNeeded
    -> FROM Shift s
    -> JOIN Department d ON s.DepartmentID = d.DepartmentID
    -> LEFT JOIN ShiftAssignment sa
    ->     ON s.ShiftID = sa.ShiftID
    ->     AND sa.AssignmentStatus = 'Assigned'
    -> GROUP BY
    ->     s.ShiftID,
    ->     d.DepartmentName,
    ->     s.ShiftDate,
    ->     s.RequiredEmployees
    -> HAVING COUNT(sa.AssignmentID) < s.RequiredEmployees
    -> ORDER BY s.ShiftDate;
Empty set (0.01 sec)

mysql> USE employee_scheduling;
Database changed
mysql> SHOW TABLES;
+-------------------------------+
| Tables_in_employee_scheduling |
+-------------------------------+
| Availability                  |
| Department                    |
| Employee                      |
| Shift                         |
| ShiftAssignment               |
| TimeRecord                    |
+-------------------------------+
6 rows in set (0.03 sec)

mysql> USE employee_scheduling;
Database changed
mysql> 
mysql> SELECT
    ->     TABLE_NAME,
    ->     COLUMN_NAME,
    ->     CONSTRAINT_NAME,
    ->     REFERENCED_TABLE_NAME,
    ->     REFERENCED_COLUMN_NAME
    -> FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
    -> WHERE TABLE_SCHEMA = 'employee_scheduling'
    ->   AND REFERENCED_TABLE_NAME IS NOT NULL
    -> ORDER BY TABLE_NAME;
+-----------------+--------------+------------------------+-----------------------+------------------------+
| TABLE_NAME      | COLUMN_NAME  | CONSTRAINT_NAME        | REFERENCED_TABLE_NAME | REFERENCED_COLUMN_NAME |
+-----------------+--------------+------------------------+-----------------------+------------------------+
| Availability    | EmployeeID   | availability_ibfk_1    | Employee              | EmployeeID             |
| Employee        | DepartmentID | employee_ibfk_1        | Department            | DepartmentID           |
| Shift           | DepartmentID | shift_ibfk_1           | Department            | DepartmentID           |
| ShiftAssignment | ShiftID      | shiftassignment_ibfk_1 | Shift                 | ShiftID                |
| ShiftAssignment | EmployeeID   | shiftassignment_ibfk_2 | Employee              | EmployeeID             |
| TimeRecord      | AssignmentID | timerecord_ibfk_1      | ShiftAssignment       | AssignmentID           |
+-----------------+--------------+------------------------+-----------------------+------------------------+
6 rows in set (0.08 sec)

mysql> USE employee_scheduling;
Database changed
mysql> SELECT * FROM Department;
+--------------+------------------+------------------+
| DepartmentID | DepartmentName   | DepartmentStatus |
+--------------+------------------+------------------+
|            1 | Sales            | Active           |
|            2 | Inventory        | Active           |
|            3 | Customer Service | Active           |
|            4 | Warehouse        | Active           |
|            5 | Administration   | Active           |
+--------------+------------------+------------------+
5 rows in set (0.06 sec)

mysql> SELECT *
    -> FROM TimeRecord
    -> WHERE ClockIn IS NULL
    ->    OR ClockOut IS NULL
    ->    OR ClockOut < ClockIn;
Empty set (0.07 sec)

mysql> SELECT
    ->     d.DepartmentName,
    ->     SUM(TIMESTAMPDIFF(MINUTE, s.StartTime, s.EndTime) / 60) AS ScheduledHours
    -> FROM Department d
    -> JOIN Shift s ON d.DepartmentID = s.DepartmentID
    -> GROUP BY d.DepartmentName;
+------------------+----------------+
| DepartmentName   | ScheduledHours |
+------------------+----------------+
| Sales            |         8.0000 |
| Inventory        |         8.0000 |
| Customer Service |         8.0000 |
| Warehouse        |         8.0000 |
+------------------+----------------+
4 rows in set (0.07 sec)

