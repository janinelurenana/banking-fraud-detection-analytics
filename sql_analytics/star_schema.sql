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
