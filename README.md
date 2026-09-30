# Enterprise E-Commerce Analytics Platform

A production-style analytics engineering project built with **dbt, Databricks, Delta Lake, and GitHub Actions**.

This project demonstrates enterprise data engineering patterns including layered data modeling, automated data quality, incremental processing, SCD Type 2 dimensions, source freshness monitoring, and CI/CD.

## Architecture

```text
Source Systems
      │
      ▼
┌─────────────────────┐
│ Raw / Bronze        │
│ Databricks          │
│                     │
│ customers           │
│ orders              │
│ order_items         │
│ + _loaded_at        │
└──────────┬──────────┘
           │
        dbt source()
           │
           ▼
┌─────────────────────┐
│ Staging             │
│                     │
│ stg_customers       │
│ stg_orders          │
│ stg_order_items     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Intermediate        │
│                     │
│ order enrichment    │
│ customer current    │
│ DQ exceptions       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Marts               │
│                     │
│ dim_customers       │
│ fct_orders          │
└──────────┬──────────┘
           │
           ▼
      Analytics / BI


Technology Stack
dbt Core
Databricks
Delta Lake
SQL
Python
Git / GitHub
GitHub Actions
Azure / cloud data-platform concepts
Key Engineering Features
Layered Data Architecture

The project follows:
Raw → Staging → Intermediate → Marts

This separates ingestion, standardization, business transformations, and analytics consumption.

Source Management

dbt source() definitions point staging models to Databricks raw tables.

Raw tables contain an _loaded_at ingestion timestamp.

Source Freshness

Source freshness is monitored using _loaded_at.

Status	Threshold
Fresh	< 24 hours
Warning	≥ 24 hours
Error	≥ 48 hours
Data Quality

Automated dbt tests cover:

Primary-key uniqueness
NOT NULL constraints
Referential integrity
Accepted values
Order-total reconciliation
Invalid customer references

Source referential-integrity exceptions are captured and monitored rather than silently discarded.

SCD Type 2

Customer history is maintained using a dbt snapshot.

Example:

Customer 1001

Bangalore
2026-09-01 → 2026-09-28

Delhi
2026-09-28 → current
Incremental Processing

fct_orders uses an incremental Delta MERGE strategy.

Orders affected by changes in order or order-item records are identified for incremental processing.

Unknown Dimension Member

Orders referencing an unknown customer are mapped to:

customer_id = -1

This represents the Unknown Customer dimension member.

CI/CD

GitHub Actions automatically runs:

dbt parse
    ↓
dbt build

for pushes to main and pull requests targeting main.

CI runs against a separate:

dbt_ci

schema to isolate CI workloads from local development.

Data Quality Example

The project intentionally contains an order referencing a customer that does not exist:

order_id    customer_id
50006       9999

The pipeline:

Detects the invalid relationship.
Records the exception in int_invalid_order_customers.
Emits a dbt warning.
Maps the customer to the Unknown Customer dimension.
Allows downstream processing to continue.
Running Locally

Activate the virtual environment:

source .venv/bin/activate

Set the Databricks profile:

export DATABRICKS_CONFIG_PROFILE=enterprise_ecommerce

Parse the project:

dbt parse

Build the project:

dbt build

Check source freshness:

dbt source freshness
CI Pipeline

The GitHub Actions workflow is:

.github/workflows/dbt-ci.yml

Pipeline:
Pull Request / Push
        ↓
Checkout
        ↓
Python setup
        ↓
Install dbt
        ↓
Create CI profile
        ↓
dbt parse
        ↓
dbt build

Future Enhancements
Production deployment environment
More robust incremental watermark / lookback logic
Product and payment dimensions
Customer behavioral event models
Additional custom data-quality tests
dbt documentation and exposures
Power BI semantic model
Deployment automation
Operational monitoring
Disclaimer

This project uses synthetic e-commerce data. The architecture and engineering patterns are designed to demonstrate production-oriented data engineering practices.


### Step 4 — save the file

In VS Code:

**⌘ + S**

### Step 5 — check Git

Back in your terminal:

```bash
git status