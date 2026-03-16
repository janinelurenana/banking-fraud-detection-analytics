# Fraud Detection & Security Monitoring Dashboard Analysis


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

# Page 3: Suspicious Accounts Investigation

![Page 3: Suspicious Accounts Investigation](/power_bi/dashboard-screenshots/suspicious-accounts-investigation.png)

**Objective:**
Enable analysts to **investigate individual accounts associated with suspicious transactions**, identify abnormal behavior patterns, and assess financial exposure linked to those accounts.

**Dashboard Visuals**

* **Account Risk Leaderboard**
  Displays the **top 5 accounts with the highest cumulative risk scores**, along with the timestamp of their most recent transaction.

  ```
  LastTransaction = MAX(fact_transactions[timestamp])
  ```

* **Financial Exposure by Merchant Entity**
  Shows which merchants contribute most to the financial exposure of flagged accounts.

* **Account Behavior Scatter Chart**
  Visualizes the **transaction history of a selected account**, allowing analysts to detect:

  * unusually large transactions
  * activity occurring at abnormal times
  * sudden deviations from the account’s historical behavior

**Dashboard Controls**

**Slicers**

* Alert Level (High / Medium)
* Location
* Merchant Entity
* Transaction Type

These filters allow analysts to **narrow investigations to specific fraud scenarios**.

**Key Metric** 
* **Financial Exposure** - Total value of transactions flagged as fraudulent for the selected account(s).

---

## Observations

### High-Risk Accounts

Two accounts stand out due to their **high cumulative risk scores and financial exposure**.

**Account 35**

* Most recent transaction: **Feb 24, 2026 – 07:20 AM**
* Total financial exposure: **PHP 540,510**
* Largest contributing merchant: **Online Sabong Portal**

  * **PHP 275,540** of exposure linked to this merchant

This indicates a significant portion of suspicious activity tied to **online gambling-related transactions**, which may represent higher-risk digital payment channels.

---

**Account 34**

* Most recent transaction: **Feb 25, 2026 – 09:45 AM**
* Total financial exposure: **PHP 334,250**
* Largest contributing merchant: **Crypto Exchange PH**

  * **PHP 206,860** linked to cryptocurrency transactions

This pattern aligns with earlier findings showing **Crypto Exchange PH as a major contributor to fraud alerts across the dataset**.

---

## Investigation Workflow

Analysts can investigate suspicious accounts by:

1. Selecting an account from the **risk leaderboard**
2. Reviewing merchant exposure associated with the account
3. Examining the **transaction history scatter chart** to detect behavioral anomalies
4. Applying filters to isolate transactions by location, merchant, or transaction type

This workflow enables analysts to **quickly assess whether suspicious activity reflects isolated incidents or broader behavioral patterns**.

---

# Page 4: Transaction Behavior Analysis

![Page 4: Transaction Behavior Analysis](/power_bi/dashboard-screenshots/transaction-behavior-analysis.png) 
**Objective:**
Analyze **transaction behavior patterns associated with fraudulent activity**, focusing on time-based trends, transaction channels, and merchant entities.

**Dashboard Visuals**

* **Hourly Fraud Incident Distribution**
  Displays the number of fraud incidents across different hours of the day to identify peak fraud windows.

```
Hour = HOUR(fact_transactions[timestamp])
```

* **Fraud Rate by Merchant Entity**
  Highlights merchants with the highest proportion of fraudulent transactions.

* **Transactions per Fraud Category**
  Shows how fraud incidents are distributed across different transaction contexts.

* **Fraud Exposure vs Transaction Volume (Gauge)**
  Compares the total financial value of fraudulent transactions against the total transaction volume.

---

## Observations

### Time-Based Fraud Patterns

Fraud activity shows a **notable concentration around midday (12:00 PM)**:

* Financial exposure: **PHP 251,000**
* Transactions largely associated with:

  * **Crypto Exchange PH**
  * **Meralco Billing**

Most of these incidents occur through the **Web transaction channel**, suggesting higher fraud exposure within online payment environments.

---

### Transaction Channel Risk

The **Web transaction type accounts for the majority of fraud activity**:

* **61.9% of fraudulent transactions**
* Financial exposure: **PHP 2.37M**

This reinforces earlier findings that **web-based transactions represent the highest-risk channel in the dataset**, potentially due to weaker identity verification or automated fraud attempts.

---

### Merchant Behavior Patterns

Fraud incidents involving **Crypto Exchange PH** show recurring activity during:

* **12:00 PM**
* **7:00 PM**

These transactions are primarily conducted through the **Web channel**, with a smaller portion occurring via **Mobile transactions**.

This pattern suggests that **fraud involving cryptocurrency-related merchants tends to cluster within specific time windows and digital transaction channels**.

---

### Overall Fraud Impact

Across the dataset:

* **Total transaction volume:** PHP **10.58M**
* **Total fraud exposure:** PHP **2.54M**

This indicates that fraudulent transactions represent a **significant financial impact relative to the overall transaction volume**.

---

# Findings Summary

Analysis of the transaction dataset between **January 2024 and January 2026** reveals several notable fraud patterns:

* **Fraud spikes occurred in October 2024 and October 2025**, each reaching a **38.71% fraud rate**, representing the highest concentration of fraudulent activity within the dataset.

* **Web-based transactions account for the majority of fraud incidents**, representing **61.9% of all fraudulent transactions** and contributing **PHP 2.37M in financial exposure**.

* The merchant **Crypto Exchange PH** consistently appears as the **largest contributor to fraud alerts**, accounting for a significant portion of suspicious transactions across multiple cities and branches.

* Fraud activity is **geographically concentrated in major urban centers**, particularly **Davao City and Cebu City**, where Crypto Exchange PH transactions frequently appear in fraud alerts.

* **High-risk accounts show concentrated exposure to specific merchants**, including cryptocurrency exchanges and online gambling platforms.

* Across the dataset, total fraudulent exposure reaches **PHP 2.54M**, compared to an overall transaction volume of **PHP 10.58M**.

---

# Risk Interpretation

Several structural risk indicators emerge from the analysis:

**1. Digital Transaction Channels Present Higher Risk**

Fraud incidents are heavily concentrated in **Web-based transactions**, suggesting that online channels may present a larger attack surface compared to physical transaction channels such as POS.

**2. Cryptocurrency-Related Merchants Represent Elevated Risk**

Transactions involving **Crypto Exchange PH** appear consistently across multiple fraud indicators, including:

* high fraud rates
* geographic clustering
* repeated involvement in high-risk accounts

Cryptocurrency platforms may introduce additional fraud risk due to **high transaction liquidity and cross-border financial flows**.

**3. Fraud Activity Shows Geographic Clustering**

Fraud alerts appear concentrated within **major financial hubs such as Davao City and Cebu City**, which may reflect:

* higher transaction volumes
* greater merchant diversity
* or targeted fraud activity within urban digital commerce environments.

**4. Fraud Exposure Is Concentrated Among a Small Set of Accounts and Merchants**

The investigation view highlights that a **limited number of accounts and merchants contribute disproportionately to fraud exposure**, suggesting that targeted monitoring of these entities could significantly reduce overall fraud impact.

---

# Operational Takeaways

Based on the observed fraud patterns, several monitoring priorities emerge:

* **Enhanced monitoring for Web-based transactions**, particularly those involving high-risk merchants.

* **Focused fraud detection rules for cryptocurrency-related transactions**, especially when combined with abnormal transaction behavior.

* **Branch-level monitoring in high-alert cities**, including Davao City and Cebu City.

* **Account-level monitoring for high-risk accounts with repeated fraud alerts**, particularly those interacting with gambling or cryptocurrency platforms.

* **Behavioral anomaly detection**, including unusual transaction timing or sudden spikes in transaction value.

These measures reflect typical strategies used in **transaction monitoring systems within financial institutions**.

---

## Notes

* All insights are **simulated**, based on synthetic data generated via the SQL seed script.
* The dashboard **mirrors real-world investigation workflows**, but no real financial or PII data is used.
* The dashboard emphasizes **investigative clarity over predictive modeling**, showing how analysts might prioritize alerts and monitor suspicious activity.

