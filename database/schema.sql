-- ============================
-- Bank Transaction Fraud Detection Schema
-- ============================

CREATE DATABASE IF NOT EXISTS bank_fraud_db;
USE bank_fraud_db;

-- Table: branches
CREATE TABLE branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_city VARCHAR(50) NOT NULL,
    branch_country VARCHAR(50) NOT NULL
);

-- Table: accounts
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- Table: merchants
CREATE TABLE merchants (
    merchant_id INT AUTO_INCREMENT PRIMARY KEY,
    merchant_name VARCHAR(100) NOT NULL,
    merchant_risk_level ENUM('low', 'medium', 'high') NOT NULL
);

-- Table: transaction_types
CREATE TABLE transaction_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

-- Table: transactions (Fact Table)
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    merchant_id INT NOT NULL,
    type_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_timestamp DATETIME NOT NULL,
    device_type VARCHAR(50) NOT NULL, -- ATM, Web, Mobile, POS
    location_city VARCHAR(50),
    location_country VARCHAR(50),
    is_international TINYINT(1) DEFAULT 0, -- 0 for False, 1 for True
    transaction_status ENUM('success', 'failed', 'pending') NOT NULL,
    fraud_flag TINYINT(1) DEFAULT 0,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id),
    FOREIGN KEY (type_id) REFERENCES transaction_types(type_id)
);

-- Indexes for Performance
CREATE INDEX idx_transactions_account_timestamp ON transactions(account_id, transaction_timestamp);
CREATE INDEX idx_transactions_merchant ON transactions(merchant_id);
CREATE INDEX idx_transactions_type ON transactions(type_id);
