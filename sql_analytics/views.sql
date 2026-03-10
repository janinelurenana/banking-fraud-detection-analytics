-- =============================================
-- Views for Fraud Detection Logic
-- =============================================

USE bank_fraud_db;

-- VIEW 1: Risk Scoring Engine
-- Assigns weights based on transaction behavior
CREATE OR REPLACE VIEW v_transaction_risk_scores AS
SELECT 
    t.transaction_id,
    -- NEW SPIKE LOGIC:
    -- +4 Risk if between 1AM-4AM (Late night fraud window)
    -- +1 Risk if December (High volume pressure)
    (CASE WHEN t.amount > 50000 THEN 3 ELSE 0 END) + 
    (CASE WHEN m.merchant_risk_level = 'high' THEN 2 ELSE 0 END) + 
    (CASE WHEN t.is_international = 1 THEN 3 ELSE 0 END) +
    (CASE WHEN HOUR(t.transaction_timestamp) BETWEEN 1 AND 4 THEN 4 ELSE 0 END) +
    (CASE WHEN MONTH(t.transaction_timestamp) = 12 THEN 1 ELSE 0 END) AS risk_score
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id;

-- VIEW 2: Fraud Investigation Console
-- Filters only high-priority alerts for the security team
CREATE OR REPLACE VIEW v_fraud_alerts AS
SELECT 
    r.transaction_id,
    a.customer_id,
    r.risk_score,
    CASE 
        WHEN r.risk_score >= 5 THEN 'High Alert'
        WHEN r.risk_score >= 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS alert_level,
    t.transaction_timestamp,
    t.location_city
FROM v_transaction_risk_scores r
JOIN transactions t ON r.transaction_id = t.transaction_id
JOIN accounts a ON t.account_id = a.account_id
WHERE r.risk_score >= 3;
