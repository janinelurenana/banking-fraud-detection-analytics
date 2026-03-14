# Banking Fraud Detection & Security Analytics – Methodology

## 1. Project Design Philosophy

This project simulates a **fraud detection and security analytics pipeline** used by financial institutions.

The architecture emphasizes a **clear separation of responsibilities**:

* **Operational data storage** – normalized relational schema for transactional integrity.
* **Analytical reporting** – star schema optimized for fast aggregation and dashboard visualization.

This separation mirrors real-world banking systems, allowing analytical workloads to run without impacting operational performance.

---

## 2. Data Generation

All data is **synthetically generated** using a **seed SQL script**.

* Ensures **no real customer or financial data** is used.
* Produces realistic but **safe banking transactions** across accounts, branches, merchants, and transaction types.
* Includes enough volume to simulate fraud patterns and test alert logic.

This approach allows the project to **mimic real banking environments** while remaining safe for portfolio demonstration.

---

## 3. Database Design Decisions

### Normalized Operational Schema

The operational database models core banking entities in a **normalized relational schema**:

* **accounts** – bank accounts linked to customers and branches
* **branches** – physical bank locations
* **merchants** – vendors with risk levels
* **transaction_types** – channel metadata (ATM, POS, Web, Mobile)
* **transactions** – detailed ledger entries

**Rationale:**

* Reduces redundancy and ensures **data integrity**.
* Supports **transactional consistency**, critical for banking operations.
* Provides a foundation for **complex queries** like risk scoring.

---

### Star Schema for Analytics

Operational tables are transformed into a **star schema** to support BI workflows:

* **fact_transactions** – central table with transaction metrics
* **dim_customers** – account and customer context
* **dim_branches** – location context
* **dim_merchants** – merchant context, including risk level
* **dim_transaction_types** – transaction channel context

**Rationale:**

* Optimized for **aggregations, filtering, and joins** in Power BI.
* Simplifies the workflow for fraud analysts, enabling **fast dashboard queries**.
* Mirrors **industry-standard data warehousing practices**.

---

## 4. Fraud Detection Strategy

Fraud detection is implemented as **rule-based SQL logic**.

### Risk Scoring

Transactions are evaluated using **weighted behavioral factors**:

| Factor                   | Weight | Explanation                                                     |
| ------------------------ | ------ | --------------------------------------------------------------- |
| Transaction > PHP 50,000 | +3     | Large transactions may indicate abnormal behavior               |
| High-risk merchant       | +2     | Merchants flagged as high-risk increase fraud probability       |
| International            | +3     | Cross-border transactions are more likely to be fraudulent      |
| Late-night activity      | +4     | Transactions between 1–4 AM fall within common fraud windows    |
| Seasonal pressure        | +1     | Transactions during December may indicate holiday-related fraud |

**Implementation:** `sql/risk_scoring.sql` → view `v_transaction_risk_scores`.

---

### Alert Classification

Transactions are categorized for analyst investigation:

| Alert Level | Risk Score |
| ----------- | ---------- |
| High Alert  | ≥ 5        |
| Medium Risk | 3 – 4      |
| Low Risk    | < 3        |

Only **Medium Risk and High Alert** transactions are exposed in the **investigation dataset** (`v_fraud_alerts`) for dashboard visualization.

**Implementation:** `sql/fraud_detection_rules.sql`.

---

## 5. Analytical Dataset Preparation

The star schema is **exported as CSV files** to serve as the source for Power BI:

* `fact_transactions.csv`
* `dim_customers.csv`
* `dim_branches.csv`
* `dim_merchants.csv`
* `dim_transaction_types.csv`
* `v_fraud_alerts.csv`

This approach separates **database modeling** from **dashboard consumption**, mimicking industry ETL/ELT pipelines.

---

## 6. Dashboard Design Approach

The Power BI dashboard (`fraud_detection_dashboard.pbix`) was designed to **mirror a security monitoring interface**:

* **Overview page** – high-level risk distribution
* **Geographic & Merchant Analysis** – identify clusters of suspicious activity
* **Account Investigation** – drill down on high-risk accounts
* **Transaction Behavior Analysis** – detect unusual patterns and spikes

Design principles:

* **Interactivity:** filters, drilldowns, slicers
* **Analyst-focused:** highlights actionable alerts, not raw data
* **Clarity:** visual cues for risk level and trends

---

## 7. Key Decisions & Justifications

| Decision                      | Rationale                                                          |
| ----------------------------- | ------------------------------------------------------------------ |
| Normalized operational schema | Ensures transactional integrity and realistic structure            |
| Star schema for analytics     | Optimizes BI performance and analyst usability                     |
| Rule-based risk scoring       | Transparent, auditable, and sufficient for portfolio demonstration |
| CSV export for Power BI       | Mimics typical ETL process; avoids direct connection complexity    |
| Dashboard focus on alerts     | Reflects real-world SOC/fraud monitoring workflow                  |

---

## 8. Limitations & Future Improvements

* **Rule-based scoring only:** Could integrate ML models for predictive detection
* **Batch data only:** No streaming or real-time detection
* **Limited synthetic dataset:** Larger datasets could improve dashboard robustness
* **No alert automation:** Future work could integrate alert pipelines or notifications

---