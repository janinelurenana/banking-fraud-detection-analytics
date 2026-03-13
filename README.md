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