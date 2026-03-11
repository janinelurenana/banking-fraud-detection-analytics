-- ==========================================================
-- PH Localized Bank Schema & Enhanced Seed (2024-2026)
-- Target: 5,500 Transactions with Seasonal Fraud Spikes
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

-- 2. INITIAL DATA INSERTION
INSERT INTO branches (branch_name, branch_city, branch_country) VALUES 
('Ayala Ave Main', 'Makati', 'Philippines'),
('Cebu IT Park Hub', 'Cebu City', 'Philippines'),
('Davao Business Center', 'Davao City', 'Philippines'),
('SM Baguio Branch', 'Baguio', 'Philippines'),
('BGC Tech Center', 'Taguig', 'Philippines');

INSERT INTO transaction_types (type_name, description) VALUES 
('ATM', 'Physical withdrawal'),
('Mobile', 'GCash/Bank App/InstaPay'),
('Web', 'Online Payment Gateway'),
('POS', 'In-store Terminal');

INSERT INTO merchants (merchant_name, merchant_risk_level) VALUES 
('SM Supermalls', 'low'),
('Meralco Billing', 'low'),
('Lazada/Shopee Seller', 'medium'),
('Online Sabong Portal', 'high'),
('Crypto Exchange PH', 'high');

-- 3. ACCOUNT GENERATOR (200 Accounts)
DELIMITER $$
CREATE PROCEDURE SeedAccounts()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 200 DO
        INSERT INTO accounts (customer_id, branch_id, account_type, balance)
        VALUES (1000 + i, FLOOR(1 + RAND() * 5), 'Savings', ROUND(10000 + RAND() * 200000, 2));
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;
CALL SeedAccounts();

-- 4. THE SEASONAL TRANSACTION GENERATOR
DELIMITER $$
CREATE PROCEDURE GeneratePHTransactions()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE start_ts DATETIME DEFAULT '2024-01-01 00:00:00';
    DECLARE end_ts DATETIME DEFAULT '2026-02-28 23:59:59';
    DECLARE range_seconds INT;
    DECLARE random_ts DATETIME;
    DECLARE rand_val FLOAT;
    DECLARE m_id INT;
    DECLARE b_city VARCHAR(50);
    DECLARE f_flag TINYINT;
    DECLARE r_score INT;
    DECLARE cur_month INT;
    
    SET range_seconds = TIMESTAMPDIFF(SECOND, start_ts, end_ts);

    WHILE i <= 5500 DO
        SET rand_val = RAND();
        -- Use a slight power function to distribute dates more naturally
        SET random_ts = TIMESTAMPADD(SECOND, FLOOR(RAND() * range_seconds), start_ts);
        SET cur_month = MONTH(random_ts);

        -- LOGIC: October Cyber Attack vs December Holiday Fraud
        IF cur_month = 10 THEN
            -- OCTOBER SPIKE: Targeted attack on Crypto/High Risk
            SET m_id = IF(RAND() > 0.4, 5, FLOOR(1 + RAND() * 4));
            SET f_flag = IF(m_id = 5 AND RAND() > 0.3, 1, 0); -- 70% fraud on crypto in Oct
            SET r_score = IF(f_flag = 1, FLOOR(90 + RAND() * 10), FLOOR(20 + RAND() * 30));
        
        ELSEIF cur_month = 12 THEN
            -- DECEMBER SPIKE: High volume merchant fraud (Lazada/Shopee)
            SET m_id = IF(RAND() > 0.5, 3, FLOOR(1 + RAND() * 4));
            SET f_flag = IF(RAND() > 0.85, 1, 0); -- 15% fraud rate (Holiday shopping scams)
            SET r_score = IF(f_flag = 1, FLOOR(75 + RAND() * 15), FLOOR(10 + RAND() * 20));
        
        ELSE
            -- NORMAL MONTHS: Low noise
            SET m_id = CASE 
                WHEN RAND() < 0.4 THEN 1 -- SM
                WHEN RAND() < 0.7 THEN 2 -- Meralco
                ELSE FLOOR(1 + RAND() * 5)
            END;
            SET f_flag = IF(RAND() > 0.98, 1, 0); -- 2% standard fraud
            SET r_score = IF(f_flag = 1, FLOOR(70 + RAND() * 20), FLOOR(0 + RAND() * 25));
        END IF;

        -- City Selection Logic
        SET rand_val = RAND();
        SET b_city = CASE 
            WHEN rand_val < 0.50 THEN 'Makati'
            WHEN rand_val < 0.70 THEN 'Cebu City'
            WHEN rand_val < 0.85 THEN 'Quezon City'
            ELSE 'Davao City'
        END;

        INSERT INTO transactions (
            account_id, merchant_id, type_id, amount, transaction_timestamp, 
            device_type, location_city, location_country, is_international, 
            transaction_status, fraud_flag, risk_score
        ) 
        VALUES (
            FLOOR(1 + RAND() * 200),
            m_id,
            CASE WHEN cur_month = 10 THEN 3 ELSE FLOOR(1 + RAND() * 4) END, -- Force Web in Oct
            CASE 
                WHEN cur_month = 10 THEN ROUND(40000 + (RAND() * 60000), 2) -- High value theft
                WHEN cur_month = 12 THEN ROUND(500 + (RAND() * 20000), 2)  -- Shopping spree
                ELSE ROUND(50 + (RAND() * 10000), 2)
            END,
            random_ts,
            IF(cur_month = 10, 'Chrome Browser', ELT(FLOOR(1 + RAND() * 4), 'Android App', 'iPhone App', 'Chrome Browser', 'ATM')),
            b_city,
            'Philippines',
            IF(cur_month = 10 AND RAND() > 0.5, 1, 0), -- Attackers often use VPNs
            'success',
            f_flag,
            r_score
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL GeneratePHTransactions();