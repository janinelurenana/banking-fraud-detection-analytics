-- =============================================
-- Star Schema for Power BI Analytics
-- =============================================

USE bank_fraud_db;

-- The Central Fact Table
-- Combines the transaction 'Fact' with necessary 'Dimensions'
CREATE OR REPLACE VIEW fact_transactions AS
SELECT 
    t.transaction_id,
    a.customer_id,
    a.branch_id,
    t.merchant_id,
    t.type_id,
    t.amount,
    t.transaction_timestamp AS timestamp,
    t.location_city,
    t.fraud_flag,
    COALESCE(r.risk_score, 0) AS risk_score
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
LEFT JOIN v_transaction_risk_scores r ON t.transaction_id = r.transaction_id;

-- 1. dim_customers (Cleaning up account/customer info)
CREATE OR REPLACE VIEW dim_customers AS
SELECT 
    account_id, 
    customer_id, 
    account_type, 
    balance
FROM accounts;

-- 2. dim_branches (Providing geographic context)
CREATE OR REPLACE VIEW dim_branches AS
SELECT 
    branch_id, 
    branch_name, 
    branch_city
FROM branches;

-- 3. dim_transaction_types (Labeling the channels)
CREATE OR REPLACE VIEW dim_transaction_types AS
SELECT 
    type_id, 
    type_name
FROM transaction_types;

-- 4. dim_merchants (Adding risk context for filtering)
CREATE OR REPLACE VIEW dim_merchants AS
SELECT 
    merchant_id, 
    merchant_name, 
    merchant_risk_level
FROM merchants;
