Data Modeling

The project follows a two-stage data model:

Normalized relational schema for transactional data

Star schema optimized for analytics and Power BI reporting

The star schema consists of:

fact_transactions
dim_customers
dim_branches
dim_merchants
dim_transaction_types

Transformation scripts are provided in:

database/star_schema.sql

repo structure

```
fraud-detection-analytics/

README.md

data/
  fact_transactions.csv
  dim_customers.csv
  dim_branches.csv
  dim_merchants.csv
  dim_transaction_types.csv
  v_fraud_alerts.csv

database/
  schema.sql
  star_schema.sql
  data_dictionary.md
  erd.png

sql/
  fraud_detection_rules.sql

powerbi/
  fraud_detection_dashboard.pbix
  dashboard_screenshots/

docs/
  methodology.md
  dashboard_explanation.md
```
