USE bank_records_db;

-- =============================================
-- RULE 1: Large Transaction Spike
-- Description: Flags transactions > 5x the account's average.
-- =============================================
SELECT 
    t.transaction_id, 
    t.account_id, 
    t.amount, 
    stats.avg_amount,
    'Large Spike' AS violation_type
FROM transactions t
JOIN (
    SELECT account_id, AVG(amount) AS avg_amount 
    FROM transactions 
    GROUP BY account_id
) stats ON t.account_id = stats.account_id
WHERE t.amount > (stats.avg_amount * 5);


-- =============================================
-- RULE 2: Impossible Travel (Location Anomaly)
-- Description: Transactions in two different cities within 1 hour.
-- =============================================
SELECT 
    t1.account_id,
    t1.location_city AS city_1,
    t2.location_city AS city_2,
    t1.transaction_timestamp AS time_1,
    t2.transaction_timestamp AS time_2,
    'Impossible Travel' AS violation_type
FROM transactions t1
JOIN transactions t2 ON t1.account_id = t2.account_id
WHERE t1.transaction_id <> t2.transaction_id
AND t1.location_city <> t2.location_city
AND t2.transaction_timestamp > t1.transaction_timestamp
AND t2.transaction_timestamp <= DATE_ADD(t1.transaction_timestamp, INTERVAL 1 HOUR);


-- =============================================
-- RULE 3: High Risk Merchant Activity
-- Description: Transactions at high-risk merchants exceeding PHP 20,000.
-- =============================================
SELECT 
    t.transaction_id,
    m.merchant_name,
    t.amount,
    'High Risk Merchant' AS violation_type
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE m.merchant_risk_level = 'high' 
AND t.amount > 20000;
