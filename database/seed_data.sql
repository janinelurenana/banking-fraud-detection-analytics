-- =============================================
-- Phase 3: Seed Data (Philippines Context)
-- Goal: Populate 5,000 transactions for analytics
-- =============================================

USE bank_fraud_db;

-- Clear any existing data to avoid primary key conflicts
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE transactions;
TRUNCATE TABLE accounts;
TRUNCATE TABLE merchants;
TRUNCATE TABLE branches;
TRUNCATE TABLE transaction_types;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Insert Philippine Branches
INSERT INTO branches (branch_name, branch_city, branch_country) VALUES 
('Ayala Ave Main', 'Makati', 'Philippines'),
('Cebu IT Park Hub', 'Cebu City', 'Philippines'),
('Davao Business Center', 'Davao City', 'Philippines'),
('SM Baguio Branch', 'Baguio', 'Philippines');

-- 2. Insert Transaction Types
INSERT INTO transaction_types (type_name, description) VALUES 
('ATM', 'Physical withdrawal'),
('Mobile', 'GCash/Bank App transfer'),
('Web', 'Online Portal'),
('POS', 'In-store swipe');

-- 3. Insert Local Merchants
INSERT INTO merchants (merchant_name, merchant_risk_level) VALUES 
('SM Supermalls', 'low'),
('Meralco Billing', 'low'),
('Lazada Seller', 'medium'),
('Online Sabong Portal', 'high'),
('Crypto Exchange PH', 'high');

-- 4. Create ~200 Sample Accounts
DROP PROCEDURE IF EXISTS SeedAccounts;
DELIMITER $$
CREATE PROCEDURE SeedAccounts()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 200 DO
        INSERT INTO accounts (customer_id, branch_id, account_type, balance)
        VALUES (1000 + i, FLOOR(1 + RAND() * 4), 'Savings', ROUND(5000 + RAND() * 100000, 2));
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;
CALL SeedAccounts();

-- 5. Generate 5,000 Transactions
DROP PROCEDURE IF EXISTS GeneratePHTransactions;
DELIMITER $$
CREATE PROCEDURE GeneratePHTransactions()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 5000 DO
        INSERT INTO transactions (
            account_id, merchant_id, type_id, amount, transaction_timestamp, 
            device_type, location_city, location_country, is_international, 
            transaction_status, fraud_flag
        ) 
        VALUES (
            FLOOR(1 + RAND() * 200),             -- Matches 200 accounts
            FLOOR(1 + RAND() * 5),               -- Matches 5 merchants
            FLOOR(1 + RAND() * 4),               -- Matches 4 types
            ROUND(50 + RAND() * 75000, 2),       -- PHP Amounts
            NOW() - INTERVAL FLOOR(RAND() * 30) DAY - INTERVAL FLOOR(RAND() * 24) HOUR, -- Date + Time
            ELT(FLOOR(1 + RAND() * 4), 'ATM', 'Web', 'Mobile', 'POS'),
            ELT(FLOOR(1 + RAND() * 4), 'Makati', 'Cebu City', 'Davao City', 'Baguio'),
            'Philippines',
            IF(RAND() > 0.9, 1, 0),              -- 10% International
