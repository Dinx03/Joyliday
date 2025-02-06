-- 1. ใช้ฐานข้อมูลที่ต้องการ
USE Joyliday;

DROP TABLE IF EXISTS CustomerReward;
DROP TABLE IF EXISTS StampHistory;
DROP TABLE IF EXISTS Stamp;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS CustomerService;
DROP TABLE IF EXISTS Reward;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS user_profiles;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Department;  -- ลบตาราง Department ถ้ามีอยู่
DROP TABLE IF EXISTS Customer;    -- ลบตาราง Customer ถ้ามีอยู่

CREATE TABLE Department (
    Department_id INT PRIMARY KEY,
    Department_name VARCHAR(255) NOT NULL,
    Location VARCHAR(255)
);

CREATE TABLE Employee (
    Employee_id INT PRIMARY KEY AUTO_INCREMENT,
    Employee_name VARCHAR(255) NOT NULL,
    Department_id INT,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
);

CREATE TABLE Customer (
    Customer_id INT PRIMARY KEY AUTO_INCREMENT,
    Customer_name VARCHAR(255) NOT NULL,
    Customer_phone VARCHAR(20),
    Email VARCHAR(255)
);

CREATE TABLE Membership (
    Membership_id INT PRIMARY KEY AUTO_INCREMENT,
    Customer_id INT,
    Balance INT,
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);

CREATE TABLE CustomerService (
    Customer_id INT,
    Employee_id INT,
    ServiceDate DATE,
    PRIMARY KEY (Customer_id, Employee_id, ServiceDate),
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id),
    FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id)
);

CREATE TABLE Reward (
    Reward_id INT PRIMARY KEY AUTO_INCREMENT,
    Reward_name VARCHAR(255),
    Points_required INT
);

CREATE TABLE CustomerReward (
    Customer_id INT,
    Reward_id INT,
    RedeemDate DATE,
    PointsUsed INT,
    Quantity INT,
    Status VARCHAR(50),
    ExpirationDate DATE,
    PRIMARY KEY (Customer_id, Reward_id),
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id),
    FOREIGN KEY (Reward_id) REFERENCES Reward(Reward_id)
);

CREATE TABLE Stamp (
    Stamp_id INT PRIMARY KEY AUTO_INCREMENT,
    Customer_id INT,
    Count INT,
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);

CREATE TABLE StampHistory (
    Stamp_id INT,
    Customer_id INT,
    DateReceived DATE,
    PRIMARY KEY (Stamp_id, Customer_id, DateReceived),
    FOREIGN KEY (Stamp_id) REFERENCES Stamp(Stamp_id),
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);

CREATE TABLE Users (
    User_id INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Points INT DEFAULT 0
);

-- เพิ่มข้อมูลในตาราง Department
INSERT INTO Department (Department_id, Department_name, Location)
VALUES 
(1, 'Top-Up', 'The Mall Life Store'),
(2, 'Customer Service', 'The Mall Life Store'),
(3, 'Cleaning', 'The Mall Life Store'),
(4, 'Reward Redemption', 'The Mall Life Store');

-- เพิ่มข้อมูลในตาราง Employee
INSERT INTO Employee (Employee_name, Department_id, Username, Password)
VALUES 
('Robert Brown', 1, 'robert', 'password1'),
('Emily Davis', 1, 'emily', 'password2'),
('Michael White', 2, 'michael', 'password3'),
('Sarah Black', 2, 'sarah', 'password4'),
('Jessica Green', 3, 'jessica', 'password5'),
('Tom Harris', 4, 'tom', 'password6'),
('Kate Wilson', 4, 'kate', 'password7');

-- เพิ่มฟิลด์ Position และ Salary ในตาราง Employee
ALTER TABLE Employee
ADD COLUMN Position VARCHAR(255),
ADD COLUMN Salary DECIMAL(10, 2);

-- อัปเดตข้อมูลพนักงาน
UPDATE Employee
SET Position = 'Manager', Salary = 50000.00
WHERE Employee_id = 1;

UPDATE Employee
SET Position = 'Assistant', Salary = 30000.00
WHERE Employee_id = 2;

UPDATE Employee
SET Position = 'Customer Service Representative', Salary = 25000.00
WHERE Employee_id = 3;

UPDATE Employee
SET Position = 'Customer Service Representative', Salary = 25000.00
WHERE Employee_id = 4;

UPDATE Employee
SET Position = 'Cleaner', Salary = 20000.00
WHERE Employee_id = 5;

UPDATE Employee
SET Position = 'Reward Specialist', Salary = 30000.00
WHERE Employee_id = 6;

UPDATE Employee
SET Position = 'Reward Specialist', Salary = 30000.00
WHERE Employee_id = 7;

-- เพิ่มข้อมูลในตาราง Customer
INSERT INTO Customer (Customer_name, Customer_phone, Email)
VALUES 
('John Doe', '123-456-7890', 'john@example.com'),
('Jane Smith', '098-765-4321', 'jane@example.com'),
('Alice Johnson', '555-555-5555', 'alice@example.com'),
('Bob Brown', '444-444-4444', 'bob@example.com');

ALTER TABLE Customer 
ADD COLUMN profile_picture_url VARCHAR(255);

ALTER TABLE Customer 
ADD COLUMN username VARCHAR(100) NOT NULL;

ALTER TABLE Customer 
DROP COLUMN username;

UPDATE Customer 
SET profile_picture_url = CASE 
    WHEN Customer_name = 'John Doe' THEN 'https://f.ptcdn.info/415/005/000/1369220776-aren2-o.jpg'
    WHEN Customer_name = 'Jane Smith' THEN 'https://i.ytimg.com/vi/I7gOiRVRMLU/maxresdefault.jpg'
    WHEN Customer_name = 'Alice Johnson' THEN 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJBkeaKr5GwaTV5PF2Yrg7rMJR3tQLa_KLfg&s'
    WHEN Customer_name = 'Bob Brown' THEN 'https://cms.dmpcdn.com/moviearticle/2023/10/19/63a67740-6e35-11ee-b658-33ab33a1560d_webp_original.webp'
END;


-- เพิ่มข้อมูลในตาราง Membership
INSERT INTO Membership (Customer_id, Balance)
VALUES 
(1, 150),
(2, 200),
(3, 100),
(4, 50);

-- เพิ่มข้อมูลในตาราง Reward
INSERT INTO Reward (Reward_name, Points_required)
VALUES 
('Teddy Bear - Small', 50),
('Teddy Bear - Medium', 100),
('Teddy Bear - Large', 150),
('Doll - Princess', 200),
('Doll - Unicorn', 250),
('Doll - Superhero', 300),
('Stuffed Dog', 150),
('Stuffed Cat', 150),
('Stuffed Rabbit', 200),
('Stuffed Elephant', 250);

-- เพิ่มคอลัมน์สำหรับ URL ของภาพ
ALTER TABLE Reward ADD Image_URL VARCHAR(255);

-- อัปเดต URL ของภาพ
UPDATE Reward SET Image_URL = 'https://ae01.alicdn.com/kf/S57b6e868af494e90abf1beeba1d33d35K.jpg_640x640q90.jpg' 
WHERE Reward_id = 1;
UPDATE Reward SET Image_URL = 'https://www.floweramacolumbus.com/assets/inc/timthumb.php?src=https://77f90f009124773797b9-5620af73f17ec7d8bbaefba0c79a0c2e.ssl.cf2.rackcdn.com/lgbear.jpg&w=800&h=800&a=c' 
WHERE Reward_id = 2;
UPDATE Reward SET Image_URL = 'https://i.pinimg.com/736x/02/c3/14/02c314f0119dc97bf8869f93d4095abe.jpg' 
WHERE Reward_id = 3;
UPDATE Reward SET Image_URL = 'https://i.pinimg.com/474x/33/ff/48/33ff4839f42b2fb1096026d103fb8731.jpg' 
WHERE Reward_id = 4;
UPDATE Reward SET Image_URL = 'https://i5.walmartimages.com/asr/49bf1e6e-6a51-4d25-b5a8-7048439d6b70.40a8e751885b43a502a2aa469506d64f.jpeg' 
WHERE Reward_id = 5;
UPDATE Reward SET Image_URL = 'https://m.media-amazon.com/images/I/81RThmNR-kL.jpg' 
WHERE Reward_id = 6;
UPDATE Reward SET Image_URL = 'https://www.ikea.com/th/en/images/products/gosig-golden-soft-toy-dog-golden-retriever__0710164_pe727367_s5.jpg' 
WHERE Reward_id = 7;
UPDATE Reward SET Image_URL = 'https://auroragift.com/cdn/shop/products/35049.jpg?v=1645741083' 
WHERE Reward_id = 8;
UPDATE Reward SET Image_URL = 'https://www.manhattantoy.com/cdn/shop/products/wbapwclvht5itzsq7bv4.jpg?v=1590507281' 
WHERE Reward_id = 9;
UPDATE Reward SET Image_URL = 'https://m.media-amazon.com/images/I/61n5QKpjctL._AC_UF894,1000_QL80_.jpg' 
WHERE Reward_id = 10;

-- เพิ่มข้อมูลในตาราง Stamp
INSERT INTO Stamp (Customer_id, Count)
VALUES 
(1, 5),
(2, 10),
(3, 3),
(4, 0);

-- เพิ่มข้อมูลในตาราง Users
INSERT INTO Users (Username, Password, Points) 
VALUES 
('admin', 'admin123', 100),
('john_doe', 'john123', 150),
('jane_smith', 'jane123', 200);

CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    points INT DEFAULT 0
);

SELECT 
    Employee.Employee_id,
    Employee.Employee_name,
    Employee.Username,
    Employee.Department_id,
    Department.Department_name,
    Department.Location
FROM 
    Employee
LEFT JOIN 
    Department ON Employee.Department_id = Department.Department_id;

-- ตรวจสอบข้อมูล
select * from user;
SELECT * FROM Reward;
SELECT * FROM Users;
SELECT * FROM Employee;
SELECT * FROM Customer;




SELECT * FROM Membership;


SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

CREATE USER 'awakas'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'awakas'@'%';
FLUSH PRIVILEGES;

DESCRIBE user;

-- เพิ่มคอลัมน์ username และสร้าง foreign key ในตาราง Customer
ALTER TABLE Customer 
ADD COLUMN username VARCHAR(100),
ADD CONSTRAINT fk_username FOREIGN KEY (username) REFERENCES user(username);








