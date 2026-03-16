# Fraud Detection & Security Monitoring Dashboard – Explanation


## Dashboard Overview

The dashboard (`fraud_detection_dashboard.pbix`) provides an **interactive interface for monitoring banking transaction risks**.

Purpose:

* Visualize high-risk transactions
* Identify suspicious accounts and merchant behavior
* Track geographic fraud patterns
* Support investigative workflows

Key features:

* Interactive filters and slicers
* Drill-down capabilities by account, branch, or merchant
* Risk score heatmaps and alert level indicators

---

# Page 1: Fraud Monitoring Overview

![Page 1: Fraud Monitoring Overview](/power_bi/dashboard-screenshots/fraud_monitoring-overview.png)

**Objective:**
Provide analysts with a **high-level summary of fraud activity across the transaction dataset**, highlighting trends in fraud rate, transaction channels, and merchant entities.

**Dashboard Visuals**

* Fraud alerts over time (time-series trend)
* Fraud distribution by transaction type
* Fraud distribution by merchant entity

**Key Metrics (Cards)**

* **Total Transactions**
* **Total Fraudulent Incidents**
* **Fraud Rate (%)**

```
Fraud Rate % =
DIVIDE(
    SUM(fact_transactions[fraud_flag]),
    COUNT(fact_transactions[transaction_id])
)
```

* **Financial Exposure (PHP)**

```
Total Fraud PHP =
CALCULATE(
    SUM(fact_transactions[amount]),
    fact_transactions[fraud_flag] = 1
)
```

---

## Observations

### Fraud Rate Trends

Between **January 2024 and January 2026**, fraud activity shows two major spikes:

* **October 2024**

  * Fraud rate: **38.71%**
  * Financial exposure: **PHP 3.26M**

* **October 2025**

  * Fraud rate: **38.71%**
  * Financial exposure: **PHP 2.14M**

These spikes indicate periods of **unusually concentrated fraudulent activity**, potentially linked to specific merchants or transaction channels.

---

### Transaction Channel Risk

Fraud incidence is highest within the **Web transaction channel**:

* Fraud rate: **12.34%**
* Financial exposure: **PHP 6.65M**

This suggests that **online transaction environments may present a higher fraud surface**, potentially due to weaker identity verification or automated attack vectors.

---

### Merchant Risk Concentration

The merchant with the highest fraud activity is **Crypto Exchange PH**:

* Fraud rate: **48.65%**
* Total transactions: **74**
* Fraudulent incidents: **36**
* Financial exposure: **PHP 3.46M**

Most of these transactions occur via the **Web channel**, which aligns with the elevated fraud rates observed in online transaction types.

---

### Recent Fraud Activity

The most recent fraud spike occurs in **December 2025**:

* Fraud rate: **19.44%**
* Financial exposure: **PHP 384,710**

This spike is primarily associated with the **POS transaction type**, with the leading merchant identified as **Meralco Billing**.

---

You’re doing the right thing by tying **city → branch → merchant** together. The main fixes needed are:

* tighten the wording
* remove repetition
* group insights logically
* correct small grammar issues
* present the findings like **analyst notes**, not raw observations

Below is a **clean, professional revision** that keeps your numbers but reads like documentation from an investigation dashboard.

---

# Page 2: Geographic & Merchant Risk Analysis

![Page 2: Geographic & Merchant Risk Analysis](/power_bi/dashboard-screenshots/geographic_and_merchant_analysis.png)

**Objective:** Identify **geographic clusters of fraudulent activity** and determine which merchants and branches are most frequently associated with fraud alerts.

**Dashboard Visuals**

* Fraud alerts by **merchant category**
* Fraud alerts by **branch**
* Geographic heatmap of fraud alerts (**Fraud by City**)

These visuals allow analysts to detect **regional fraud concentrations** and identify merchants consistently linked to suspicious transactions.

---

## Observations

### Geographic Fraud Clusters

Two cities show the highest concentration of fraud alerts between **January 2024 and January 2026**:

**Davao City**

* **21 total fraud alerts**
* **14 transactions linked to Crypto Exchange PH**

**Cebu City**

* **18 total fraud alerts**
* **10 transactions linked to Crypto Exchange PH**

These findings indicate that a significant portion of fraud activity in both locations is associated with **transactions involving the same merchant entity**.

---

### Merchant Risk Concentration

The merchant **Crypto Exchange PH** generates the **highest number of fraud alerts across the dataset**.

Branch-level activity shows:

* **14 alerts** originating from **Davao Business Center**
* **10 alerts** originating from **Cebu IT Park Hub**

This pattern suggests that **fraud activity involving Crypto Exchange PH is geographically concentrated in major urban financial hubs**.

---

### Branch-Level Fraud Distribution

Across the monitored branches, **Crypto Exchange PH consistently appears as the merchant with the highest fraud alerts**.

Branches where Crypto Exchange PH leads fraud alerts:

* Davao Business Center
* Cebu IT Park Hub
* BGC Tech Center
* Ayala Ave Main

An exception is observed at **SM Baguio Branch**, where **Meralco Billing** shows the highest fraud incidence:

* **9 total transactions**
* **4 flagged as fraudulent**

This indicates that while **Crypto Exchange PH dominates fraud alerts overall**, other merchants may represent **localized fraud risks within specific branches**.

---

## Page 3: Suspicious Accounts Investigation

**Objective:** Drill down to **accounts involved in risky transactions**.

Typical visuals:

* List of accounts with risk score totals
* Transactions per account vs historical averages
* Time-series of account-specific activity

**Insights/Use:**

> [Add your findings here – e.g., accounts with repeated alerts, unusual transaction amounts, or odd timing patterns.]

---

## Page 4: Transaction Behavior Analysis

**Objective:** Examine **behavioral patterns** in transactions.

Typical visuals:

* Risk score trends over time
* Transaction types vs risk levels
* Late-night vs daytime transaction distribution

**Insights/Use:**

> [Add your findings here – e.g., spikes in late-night activity, risky international transactions, or unusual patterns by transaction type.]

---

## Findings Summary

This section is reserved for **consolidated observations and conclusions** derived from dashboard exploration.

**Template:**

* High-level trends (e.g., which branches, merchants, or accounts are most frequently flagged)
* Behavioral patterns that may indicate fraud (e.g., late-night or unusually large transactions)
* Risk distribution insights (e.g., percentages of high, medium, and low-risk transactions)
* Potential areas for further investigation or system improvement

> [Add your final findings here.]

---

## Notes

* All insights are **simulated**, based on synthetic data generated via the SQL seed script.
* The dashboard **mirrors real-world investigation workflows**, but no real financial or PII data is used.
* The dashboard emphasizes **investigative clarity over predictive modeling**, showing how analysts might prioritize alerts and monitor suspicious activity.

---
**Risk Interpretation**

The concentration of fraud alerts linked to Crypto Exchange PH across multiple branches suggests that cryptocurrency-related transactions may represent a higher-risk category within the dataset. Additionally, the geographic clustering of alerts in major urban centers such as Davao City and Cebu City may reflect higher transaction volumes or targeted fraud activity in these locations.