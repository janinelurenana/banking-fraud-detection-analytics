USE bank_fraud_db;

-- Clear previous data to avoid duplicates
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE branches;
TRUNCATE TABLE merchants;
SET FOREIGN_KEY_CHECKS = 1;

-- Localized Branches [cite: 65, 71]
INSERT INTO branches (branch_name, branch_city, branch_country) VALUES 
('BGC High Street Branch', 'Taguig', 'Philippines'),
('Colon Street Hub', 'Cebu City', 'Philippines'),
('Abreeza Center Office', 'Davao City', 'Philippines'),
('Session Road Branch', 'Baguio', 'Philippines');

-- Localized Merchants with Risk Levels [cite: 67, 135, 136]
INSERT INTO merchants (merchant_name, merchant_risk_level) VALUES 
('SM Supermarket', 'low'),
('Meralco Payment Center', 'low'),
('Lazada PH Seller', 'medium'),
('Online Sabong Portal', 'high'),
('GCash Crypto Exchange', 'high');

USE bank_fraud_db;

-- Drop the old version so we can update it
DROP PROCEDURE IF EXISTS GenerateTransactions;

DELIMITER $$

CREATE PROCEDURE GenerateTransactions()
BEGIN
    DECLARE i INT DEFAULT 1;
    -- Resetting the transactions table for a fresh start
    TRUNCATE TABLE transactions;
    
    WHILE i <= 5000 DO
        INSERT INTO transactions (
            account_id, 
            merchant_id, 
            type_id, 
            amount, 
            transaction_timestamp, 
            device_type, 
            location_city, 
            location_country, 
            is_international, 
            transaction_status, 
            fraud_flag
        ) 
        VALUES (
            FLOOR(1 + RAND() * 4),              -- Based on 4 test accounts [cite: 111]
            FLOOR(1 + RAND() * 5),              -- Based on 5 local merchants [cite: 67]
            FLOOR(1 + RAND() * 4),              -- ATM, Mobile, Web, or POS [cite: 114, 115, 116, 117]
            ROUND(100 + RAND() * 50000, 2),     -- Amounts in PHP (100 to 50k) [cite: 87]
            NOW() - INTERVAL FLOOR(RAND() * 30) DAY - INTERVAL FLOOR(RAND() * 24) HOUR, -- Date + Time [cite: 96]
            ELT(FLOOR(1 + RAND() * 4), 'ATM', 'Web', 'Mobile', 'POS'), [cite: 89, 252]
            ELT(FLOOR(1 + RAND() * 4), 'Taguig', 'Cebu City', 'Davao City', 'Baguio'), [cite: 90]
            'Philippines', [cite: 91]
            IF(RAND() > 0.9, 1, 0),             -- 10% chance of being international [cite: 92, 118]
            'success', [cite: 93]
            0                                   -- All start as 0; we flag them in Phase 4 [cite: 94, 127]
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Execute the localized generation
CALL GenerateTransactions();
