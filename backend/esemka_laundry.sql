-- -----------------------------
-- Database Creation
-- -----------------------------
CREATE DATABASE IF NOT EXISTS esemka_laundry;
USE esemka_laundry;

-- -----------------------------
-- Master Tables
-- -----------------------------
CREATE TABLE Job (
    JobID INT AUTO_INCREMENT PRIMARY KEY,
    JobName VARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    JobID INT,
    FOREIGN KEY (JobID) REFERENCES Job(JobID)
);

CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL UNIQUE,
    Address TEXT NOT NULL
);

CREATE TABLE Unit (
    UnitID INT AUTO_INCREMENT PRIMARY KEY,
    UnitName VARCHAR(50) NOT NULL
);

CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Service (
    ServiceID INT AUTO_INCREMENT PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    EstimationTime INT NOT NULL,
    CategoryID INT,
    UnitID INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (UnitID) REFERENCES Unit(UnitID)
);

CREATE TABLE Package (
    PackageID INT AUTO_INCREMENT PRIMARY KEY,
    PackageName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    EstimationTime INT NOT NULL
);

CREATE TABLE DetailPackage (
    DetailPackageID INT AUTO_INCREMENT PRIMARY KEY,
    PackageID INT,
    ServiceID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID),
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID)
);

-- -----------------------------
-- Transaction Tables
-- -----------------------------
CREATE TABLE HeaderTransaction (
    HeaderTransactionID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TransactionDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EmployeeID INT,
    IsPickup BOOLEAN DEFAULT FALSE,
    PickupAddress TEXT,
    Discount DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE DetailTransaction (
    DetailTransactionID INT AUTO_INCREMENT PRIMARY KEY,
    HeaderTransactionID INT,
    ServiceID INT DEFAULT NULL,
    PackageID INT DEFAULT NULL,
    Quantity INT NOT NULL,
    Subtotal DECIMAL(10,2),
    EstimationTime INT,
    IsCompleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (HeaderTransactionID) REFERENCES HeaderTransaction(HeaderTransactionID),
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID)
);

-- -----------------------------
-- Pickup Request & Notification (for Mobile)
-- -----------------------------
CREATE TABLE PickupRequest (
    PickupID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    RequestDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Picked Up', 'Processing', 'Completed', 'Delivered') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Notification (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    Message TEXT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsRead BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
