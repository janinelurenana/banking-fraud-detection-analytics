USE bank_fraud_db;

-- Create a View to calculate Risk Scores per transaction
CREATE OR REPLACE VIEW v_transaction_risk_scores AS
SELECT 
    t.transaction_id,
    t.account_id,
    (CASE WHEN t.amount > 50000 THEN 3 ELSE 0 END) + -- High value [cite: 145]
    (CASE WHEN m.merchant_risk_level = 'high' THEN 2 ELSE 0 END) + -- Risky merchant [cite: 150]
    (CASE WHEN t.is_international = 1 THEN 3 ELSE 0 END) AS risk_score -- Location anomaly [cite: 149]
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id;

-- Create an Alerts View for Power BI
CREATE OR REPLACE VIEW v_fraud_alerts AS
SELECT 
    r.transaction_id,
    r.account_id,
    r.risk_score,
    CASE 
        WHEN r.risk_score >= 5 THEN 'High Alert' -- [cite: 162]
        WHEN r.risk_score >= 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS alert_level,
    t.transaction_timestamp
FROM v_transaction_risk_scores r
JOIN transactions t ON r.transaction_id = t.transaction_id
WHERE r.risk_score >= 3; -- Only show medium to high risk [cite: 162]
