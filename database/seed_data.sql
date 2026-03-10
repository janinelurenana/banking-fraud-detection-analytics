-- ==========================================================
-- Phase 3: Enhanced Seed Data (2024-2026 Timeline)
-- Goal: 5,000 Transactions with Seasonality & Time-Based Risk
-- ==========================================================

USE bank_fraud_db;

-- Reset all tables
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
('SM Baguio Branch', 'Baguio', 'Philippines'),
('BGC Tech Center', 'Taguig', 'Philippines');

-- 2. Insert Transaction Types
INSERT INTO transaction_types (type_name, description) VALUES 
('ATM', 'Physical withdrawal'),
('Mobile', 'GCash/Bank App/InstaPay'),
('Web', 'Online Payment Gateway'),
('POS', 'In-store Terminal');

-- 3. Insert Local Merchants (Categorized for Risk)
INSERT INTO merchants (merchant_name, merchant_risk_level) VALUES 
('SM Supermalls', 'low'),
('Meralco Billing', 'low'),
('Lazada/Shopee Seller', 'medium'),
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
        VALUES (1000 + i, FLOOR(1 + RAND() * 5), 'Savings', ROUND(10000 + RAND() * 200000, 2));
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;
CALL SeedAccounts();

-- 5. Enhanced Transaction Generator (2024 - 2026)
DROP PROCEDURE IF EXISTS GeneratePHTransactions;
DELIMITER $$
CREATE PROCEDURE GeneratePHTransactions()
BEGIN
    DECLARE i INT DEFAULT 1;
    -- Define Timeline: Jan 1, 2024 to Feb 28, 2026
    DECLARE start_ts DATETIME DEFAULT '2024-01-01 00:00:00';
    DECLARE end_ts DATETIME DEFAULT '2026-02-28 23:59:59';
    DECLARE range_seconds INT;
    DECLARE random_ts DATETIME;
    DECLARE is_december BOOLEAN;
    
    SET range_seconds = TIMESTAMPDIFF(SECOND, start_ts, end_ts);

    WHILE i <= 5000 DO
        -- Generate a timestamp spread across the 26-month period
        SET random_ts = TIMESTAMPADD(SECOND, FLOOR(RAND() * range_seconds), start_ts);
        SET is_december = (MONTH(random_ts) = 12);

        INSERT INTO transactions (
            account_id, merchant_id, type_id, amount, transaction_timestamp, 
            device_type, location_city, location_country, is_international, 
            transaction_status, fraud_flag
        ) 
        VALUES (
            FLOOR(1 + RAND() * 200),
            FLOOR(1 + RAND() * 5),
            FLOOR(1 + RAND() * 4),
            -- Logic: DECEMBER SPIKE (higher amounts for Christmas shopping)
            CASE 
                WHEN is_december THEN ROUND(500 + (RAND() * 125000), 2)
                ELSE ROUND(50 + (RAND() * 75000), 2)
            END,
            random_ts,
            ELT(FLOOR(1 + RAND() * 4), 'Android App', 'iPhone App', 'Chrome Browser', 'ATM'),
            ELT(FLOOR(1 + RAND() * 5), 'Makati', 'Cebu City', 'Davao City', 'Baguio', 'Quezon City'),
            'Philippines',
            IF(RAND() > 0.9, 1, 0), -- 10% International transactions
            'success',
            0
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL GeneratePHTransactions();