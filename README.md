# Banking Fraud Detection & Security Monitoring Analytics

## Executive Summary

Financial institutions rely on continuous monitoring of transaction activity to detect fraud and protect customer accounts.

This project simulates a simplified fraud detection and security analytics pipeline, demonstrating how transactional banking data can be transformed into investigative datasets and visualized in a monitoring dashboard.

This project implements a **full-stack analytics workflow**, including:

* Relational database design
* Fraud detection logic implemented in SQL
* Analytical modeling using a star schema
* Interactive dashboard development using Power BI

The final output is a **fraud monitoring & investigation dashboard** that allows analysts to identify suspicious transactions, high-risk merchants, and behavioral anomalies across accounts and regions.

---
# Security Analysis Context
In modern financial systems, fraud detection functions similarly to
security monitoring systems used in cybersecurity operations.

Suspicious transactions are treated as security events that must be
identified, prioritized, and investigated by analysts.

This project models a simplified fraud monitoring workflow where
transactions are scored for risk, classified into alert tiers,
and visualized in a monitoring dashboard for investigation.


---

# Project Objectives

This project demonstrates how fraud detection analytics can be implemented using a structured data pipeline.

Key objectives include:

* Designing a **normalized banking database schema**
* Implementing **rule-based fraud detection logic**
* Transforming operational data into an **analytics-ready star schema**
* Building a **dashboard for fraud monitoring and investigation**
* Documenting the complete analytics workflow from database design to visualization

---

# End-to-End Data Pipeline

The system models a simplified fraud analytics architecture used in financial institutions.

```
Database Design
      ↓
SQL Fraud Detection Logic
      ↓
Analytical Dataset (Star Schema)
      ↓
Fraud Monitoring & Investigation Dashboard
```

Each stage of this pipeline is implemented and documented within this repository.

---

# Data Modeling

The project follows a **two-stage data model**, separating operational banking data from analytical reporting structures.

## 1. Normalized Relational Schema (Operational Layer)

The operational database models core banking entities using normalized tables.

Key entities include:

* Accounts
* Branches
* Merchants
* Transaction types
* Transactions

The relational schema definition can be found in:

```
database/schema.sql
```

The database structure is visualized in:

```
database/erd.png
```

Detailed documentation of all fields is available in:

```
database/data_dictionary.md
```

---

## 2. Star Schema (Analytics Layer)

To support analytics and reporting, the operational dataset is transformed into a **star schema** optimized for BI tools.

The star schema consists of:

```
fact_transactions
dim_customers
dim_branches
dim_merchants
dim_transaction_types
```

The transformation logic used to build the analytical model is implemented in:

```
database/star_schema.sql
```

The resulting analytical tables are exported as CSV datasets and stored in:

```
data/
```

These files serve as the data source for the fraud analytics dashboard.

---

# Fraud Detection Logic

Fraud detection in this project is implemented using **rule-based risk scoring in SQL**.

Each transaction is evaluated by a scoring engine that assigns weights to behavioral indicators commonly associated with fraudulent activity.

The implementation can be found in:

```
sql/risk_scoring.sql
```

---

## Risk Scoring Engine

The scoring engine is implemented as the SQL view:

```
v_transaction_risk_scores
```

This view evaluates each transaction and computes a **risk score** based on several weighted conditions.

| Risk Factor               | Weight | Explanation                                                                                                                                        |
| ------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Large Transaction         | +3     | Transactions above PHP 50,000 may indicate abnormal spending patterns.                                                                             |
| High-Risk Merchant        | +2     | Merchants categorized as high risk increase fraud probability.                                                                                     |
| International Transaction | +3     | Cross-border transactions are commonly associated with fraud attempts.                                                                             |
| Late Night Activity       | +4     | Transactions between **1:00 AM and 4:00 AM** fall within a known fraud window.                                                                     |
| Seasonal Pressure         | +1     | Transactions occurring in **December** receive additional weight due to increased financial activity and fraud attempts during the holiday season. |

The final risk score is calculated as the **sum of all triggered conditions**.

---

## Fraud Alert Classification

Transactions are categorized into investigation tiers using:

```
v_fraud_alerts
```

Alert levels are assigned as follows:

| Alert Level | Risk Score |
| ----------- | ---------- |
| High Alert  | ≥ 5        |
| Medium Risk | 3 – 4      |
| Low Risk    | < 3        |

Only **Medium Risk and High Alert transactions** are included in the investigation dataset.

The resulting dataset is exported to:

```
data/v_fraud_alerts.csv
```

This dataset powers the fraud monitoring dashboard.

---

# Fraud Monitoring & Investigation Dashboard

The analytical dataset is visualized using an interactive dashboard built in Power BI.

The dashboard enables analysts to:

* Monitor suspicious transaction activity
* Identify high-risk merchants
* Detect geographic fraud patterns
* Investigate suspicious customer accounts
* Analyze transaction behavior and risk distribution

The dashboard file can be found in:

```
powerbi/fraud_detection_dashboard.pbix
```

Preview images of the dashboard are available in:

```
powerbi/dashboard_screenshots/
```

Full analysis of the dashboard and metrics can be found in:

```
docs/fraud_dashboard_analysis.md
```

---

# Methodology

The design decisions and workflow used to implement the system are documented in:

```
docs/system_design.md
```

This document explains:

* Database design approach
* Fraud detection rule development
* Star schema transformation strategy
* Dashboard analytics design

---

# Key Skills Demonstrated

This project demonstrates several technical capabilities relevant to data engineering, analytics, and security monitoring.

**Database Engineering**

* Relational schema design
* Entity-relationship modeling
* Data normalization

**SQL Analytics**

* Risk scoring algorithms
* Fraud detection rule implementation
* Analytical query development

**Data Modeling**

* Star schema design
* Fact and dimension table modeling
* Analytical dataset preparation

**Data Visualization**

* Dashboard design for investigation workflows
* Analytical reporting and monitoring

**Security Analytics**

* Fraud pattern detection
* Transaction risk scoring
* Behavioral anomaly detection

---

# Data Disclaimer

All datasets included in this repository are **synthetically generated for demonstration purposes**.

The transaction records were produced using a **seed SQL script that generates simulated banking activity**, ensuring that:

* No real financial data is used
* No personally identifiable information (PII) is included
* The dataset is safe for educational and portfolio use

The generated data is then transformed into the analytical datasets used by the dashboard.

---

# Technologies Used

* SQL
* Relational Database Design
* Star Schema Data Modeling
* Fraud Risk Analytics
* Data Visualization (Power BI)

---

# Repository Structure
The following layout organizes the project components across
database design, SQL analytics, and dashboard implementation.

```
fraud-detection-analytics/

README.md                     # Project overview and architecture explanation

data/                         # Analytical datasets used by the dashboard
  fact_transactions.csv       # Fact table containing transaction metrics
  dim_customers.csv           # Customer/account dimension
  dim_branches.csv            # Branch location dimension
  dim_merchants.csv           # Merchant metadata and risk tiers
  dim_transaction_types.csv   # Transaction channel metadata
  v_fraud_alerts.csv          # Fraud investigation dataset generated from risk scoring

database/                      # Database design and modeling artifacts
  schema.sql                   # Normalized relational schema (operational layer)
  star_schema.sql              # SQL transformations creating the analytics star schema
  data_dictionary.md           # Documentation of tables, columns, and business meaning
  erd.png                      # Entity-Relationship diagram of the database

sql/                           # Fraud detection logic implemented in SQL
  risk_scoring.sql             # Risk scoring engine for transaction evaluation
  fraud_detection_rules.sql    # Alert classification and anomaly detection logic

powerbi/                       # Dashboard implementation
  fraud_detection_dashboard.pbix
  dashboard_screenshots/       # Static previews of the dashboard

docs/                          # Supporting documentation
  system_design.md             # Design decisions and workflow explanation
  fraud_dashboard_analysis.md  # Breakdown of dashboard pages and metrics
```

---

# Author

**Christelle Janine Lureñana**  
Designed the database, implemented the fraud detection logic, and developed the Power BI dashboard.

**Email:** lchristellejanine@gmail.com  
**LinkedIn:** https://www.linkedin.com/in/lurenanachristellejanine/  
**GitHub:** https://github.com/janinelurenana


---

# License

This project is provided for educational and portfolio purposes.