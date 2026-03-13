# Data Dictionary — Banking Fraud Detection Analytics

## Overview

This document describes the structure of the banking fraud analytics dataset used in this project. The system follows a two-layer architecture:

1. **Operational Layer (Normalized Tables)** – Represents the raw banking records stored in the transactional database.
2. **Analytics Layer (Star Schema)** – Optimized for business intelligence tools such as Microsoft Power BI.

The dataset simulates a banking environment where transaction activity is monitored for potential fraud using rule-based risk scoring.

---

# 1. Operational Database Schema (Physical Layer)

These tables represent the normalized transactional data stored in the database `bank_records_db`.

---

## Table: `branches`

| Column           | Data Type    | Key | Description                                                 |
| ---------------- | ------------ | --- | ----------------------------------------------------------- |
| `branch_id`      | INT          | PK  | Unique identifier for each bank branch.                     |
| `branch_name`    | VARCHAR(100) | -   | Official name of the branch (e.g., "Ayala Ave Main").       |
| `branch_city`    | VARCHAR(50)  | -   | City in the Philippines where the branch operates.          |
| `branch_country` | VARCHAR(50)  | -   | Country where the branch is located (default: Philippines). |

---

## Table: `accounts`

| Column         | Data Type     | Key | Description                                       |
| -------------- | ------------- | --- | ------------------------------------------------- |
| `account_id`   | INT           | PK  | Unique identifier for each bank account.          |
| `customer_id`  | INT           | -   | Identifier for the customer who owns the account. |
| `branch_id`    | INT           | FK  | References `branches.branch_id`.                  |
| `account_type` | VARCHAR(50)   | -   | Account classification (e.g., Savings, Checking). |
| `balance`      | DECIMAL(15,2) | -   | Current available account balance in PHP.         |

---

## Table: `merchants`

| Column                | Data Type    | Key | Description                                      |
| --------------------- | ------------ | --- | ------------------------------------------------ |
| `merchant_id`         | INT          | PK  | Unique identifier for each merchant or vendor.   |
| `merchant_name`       | VARCHAR(100) | -   | Merchant name (e.g., "SM Supermalls", "Lazada"). |
| `merchant_risk_level` | ENUM         | -   | Risk classification: `low`, `medium`, `high`.    |

---

## Table: `transaction_types`

| Column      | Data Type   | Key | Description                                        |
| ----------- | ----------- | --- | -------------------------------------------------- |
| `type_id`   | INT         | PK  | Unique identifier for the transaction channel.     |
| `type_name` | VARCHAR(50) | -   | Transaction channel (e.g., ATM, Mobile, Web, POS). |

---

## Table: `transactions`

| Column                  | Data Type     | Key | Description                                                           |
| ----------------------- | ------------- | --- | --------------------------------------------------------------------- |
| `transaction_id`        | INT           | PK  | Unique ledger entry for each transaction.                             |
| `account_id`            | INT           | FK  | References `accounts.account_id`.                                     |
| `merchant_id`           | INT           | FK  | References `merchants.merchant_id`.                                   |
| `type_id`               | INT           | FK  | References `transaction_types.type_id`.                               |
| `amount`                | DECIMAL(15,2) | -   | Transaction value in Philippine Peso (PHP).                           |
| `transaction_timestamp` | DATETIME      | -   | Date and time the transaction occurred.                               |
| `device_type`           | VARCHAR(50)   | -   | Device used to initiate the transaction (e.g., Android, iPhone, Web). |
| `location_city`         | VARCHAR(50)   | -   | City where the transaction originated.                                |
| `is_international`      | TINYINT(1)    | -   | Boolean indicator (1 = international transaction, 0 = domestic).      |
| `fraud_flag`            | TINYINT(1)    | -   | Indicates confirmed fraud activity.                                   |
| `risk_score`            | INT           | -   | Computed transaction risk score based on detection rules.             |

---

# 2. Analytics Data Model (Star Schema)

The analytics layer is optimized for reporting and interactive analysis using business intelligence tools.

The model follows a **star schema**, where a central fact table is connected to several dimension tables.

---

## Fact Table

### `fact_transactions`

The central dataset used for quantitative analysis.

Key metrics include:

| Column                  | Description                                         |
| ----------------------- | --------------------------------------------------- |
| `transaction_id`        | Unique transaction identifier.                      |
| `amount`                | Monetary value of the transaction.                  |
| `transaction_timestamp` | Timestamp used for time-based analysis.             |
| `risk_score`            | Risk score generated by the fraud detection engine. |

This table is linked to multiple dimension tables that provide descriptive context.

---

## Dimension Tables

### `dim_customers`

| Column            | Description                                      |
| ----------------- | ------------------------------------------------ |
| `account_id` (PK) | Unique identifier for each account.              |
| `customer_id`     | Customer identifier associated with the account. |
| `account_type`    | Type of account (Savings, Checking).             |
| `balance`         | Current account balance.                         |

---

### `dim_branches`

| Column           | Description                            |
| ---------------- | -------------------------------------- |
| `branch_id` (PK) | Unique identifier for the bank branch. |
| `branch_name`    | Branch name.                           |
| `branch_city`    | City where the branch operates.        |

---

### `dim_merchants`

| Column                | Description                           |
| --------------------- | ------------------------------------- |
| `merchant_id` (PK)    | Unique merchant identifier.           |
| `merchant_name`       | Merchant trading name.                |
| `merchant_risk_level` | Risk classification for the merchant. |

---

### `dim_transaction_types`

| Column         | Description                                  |
| -------------- | -------------------------------------------- |
| `type_id` (PK) | Transaction channel identifier.              |
| `type_name`    | Transaction channel (ATM, Mobile, Web, POS). |

---

# 3. Fraud Detection Logic & Risk Scoring

The system includes rule-based fraud detection logic that evaluates transactions and assigns a risk score.

---

## View: `v_transaction_risk_scores`

This view calculates the risk score for each transaction based on weighted indicators.

| Risk Factor               | Weight | Condition                                   |
| ------------------------- | ------ | ------------------------------------------- |
| Late Night Activity       | +4     | Transaction occurs between 01:00 and 04:00. |
| International Transaction | +3     | `is_international = 1`.                     |
| Large Transaction         | +3     | Transaction amount exceeds PHP 50,000.      |
| High Risk Merchant        | +2     | Merchant classified as `high` risk.         |
| Seasonal Pressure         | +1     | Transaction occurs during December.         |

The resulting risk score is used to prioritize suspicious transactions.

---

## View: `v_fraud_alerts`

This view classifies transactions into alert categories for investigation.

| Alert Level | Risk Score Condition                      |
| ----------- | ----------------------------------------- |
| High Alert  | Risk score ≥ 5                            |
| Medium Risk | Risk score between 3 and 4                |
| Low Risk    | Risk score < 3 (excluded from alert view) |

This dataset is used to power the fraud monitoring dashboard.

---

# 4. Advanced Fraud Detection Rules

Additional anomaly detection rules are implemented to identify suspicious behavioral patterns.

### Impossible Travel

Flags accounts that perform transactions in two different cities within the same hour (e.g., Makati and Davao).

---

### Large Transaction Spike

Flags transactions exceeding **five times the account’s historical average transaction amount**.

---

### High-Risk Merchant Threshold

Triggers an immediate alert when:

* Transaction amount > PHP 20,000
* Merchant risk level = `high`

---

# Summary

This system simulates a simplified **banking fraud detection pipeline**, consisting of:

1. A normalized transactional database
2. A star schema optimized for analytics
3. Rule-based fraud detection logic
4. Alert classification for security investigation

The resulting dataset powers an interactive dashboard built in Microsoft Power BI for monitoring suspicious financial activity.