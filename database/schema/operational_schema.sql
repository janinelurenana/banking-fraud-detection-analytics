-- ==========================================================
-- PH Localized Bank Schema
-- ==========================================================

DROP DATABASE IF EXISTS bank_records_db;
CREATE DATABASE bank_records_db;
USE bank_records_db;

-- 1. TABLE STRUCTURES
CREATE TABLE branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_city VARCHAR(50) NOT NULL,
    branch_country VARCHAR(50) NOT NULL
);

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE merchants (
    merchant_id INT AUTO_INCREMENT PRIMARY KEY,
    merchant_name VARCHAR(100) NOT NULL,
    merchant_risk_level ENUM('low', 'medium', 'high') NOT NULL
);

CREATE TABLE transaction_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    merchant_id INT NOT NULL,
    type_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_timestamp DATETIME NOT NULL,
    device_type VARCHAR(50) NOT NULL, 
    location_city VARCHAR(50),
    location_country VARCHAR(50),
    is_international TINYINT(1) DEFAULT 0,
    transaction_status ENUM('success', 'failed', 'pending') NOT NULL,
    fraud_flag TINYINT(1) DEFAULT 0,
    risk_score INT DEFAULT 0, -- Fix: Added missing column from your previous draft
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id),
    FOREIGN KEY (type_id) REFERENCES transaction_types(type_id)
);