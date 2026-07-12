# Product Analytics & A/B Testing using Google BigQuery & Power BI

An end-to-end Product Analytics project built using the Google Analytics 4 (GA4) Public Ecommerce Dataset on Google BigQuery. The project demonstrates how raw event-level data can be transformed into actionable business insights through SQL, product analytics, and interactive Power BI dashboards.

---

## Project Overview

This project simulates the workflow of a Product Data Analyst by:

- Exploring and profiling GA4 event-level data
- Building analytics-ready models using SQL
- Analyzing user behavior through conversion funnels
- Measuring cohort retention
- Simulating and evaluating an A/B experiment
- Creating an executive Power BI dashboard for stakeholders

---

## Business Objectives

The project answers key business questions such as:

- Where do users drop off during the purchase journey?
- Which marketing channels generate the highest revenue?
- Which devices and countries contribute the most revenue?
- How well do users return after their first visit?
- Does Variant B outperform Variant A?

---

## Tech Stack

- Google BigQuery
- SQL (CTEs, Window Functions, Nested Fields)
- Power BI
- Google Analytics 4 Public Ecommerce Dataset
- Git & GitHub

---

## Project Structure

```
Product-Analytics/
│
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_data_profiling.sql
│   ├── 03_data_modeling.sql
│   └── 04_product_analytics.sql
│
├── dashboard/
│   ├── Product Analytics.pbix
│   └── Product Analytics.pdf
│
├── screenshots/
│   ├── bigquery_query.png
│   ├── dashboard_overview.png
│   ├── funnel_analysis.png
│   └── retention_experiment.png
│
└── README.md
```

---

#  Dashboard Pages

## 1. Executive Summary

Displays key business KPIs including:

- Total Users
- Revenue
- Conversion Rate
- Daily Active Users
- Revenue by Device
- Revenue by Country
- Traffic Source Performance

---

## 2. Conversion Funnel

Analyzes the user journey:

```
Session Start
      ↓
View Item
      ↓
Add to Cart
      ↓
Checkout
      ↓
Purchase
```

Highlights the largest conversion drop-off and provides optimization recommendations.

---

## 3. Retention & Experiment Analysis

Includes:

- User Retention Trend
- Simulated A/B Test Comparison
- Executive Summary & Product Recommendations

---

# Key Insights

- Desktop generated the highest revenue (57.7%) while mobile contributed 40.5%.
- The largest funnel drop-off occurred between Session Start and View Item.
- Google was the highest-performing acquisition source.
- Variant A and Variant B produced nearly identical conversion rates, indicating no meaningful improvement from the experiment.

---

# Skills Demonstrated

- Product Analytics
- SQL
- BigQuery
- Data Cleaning
- Data Profiling
- Data Modeling
- Conversion Funnel Analysis
- Cohort Retention
- A/B Testing
- Dashboard Design
- Business Storytelling

---

# Dashboard Preview

## Executive Dashboard

![Executive Dashboard](https://github.com/dinesh0110/Product-analytics-bigquery/blob/main/screenshots/executive_dashboard.png)

---

## Conversion Funnel

![Conversion Funnel](https://github.com/dinesh0110/Product-analytics-bigquery/blob/main/screenshots/funnel_analysis.png)

---

## Retention & A/B Testing

![Retention Dashboard](https://github.com/dinesh0110/Product-analytics-bigquery/blob/main/screenshots/retention_experiment.png)

---

## BigQuery SQL

![BigQuery](https://github.com/dinesh0110/Product-analytics-bigquery/blob/main/screenshots/bigquery.png)

---

# Dataset

Google Analytics 4 Public Ecommerce Dataset

Source:

https://console.cloud.google.com/marketplace/product/bigquery-public-data/ga4-obfuscated-sample-ecommerce

---

# Future Improvements

- Statistical significance testing using Python
- Automated ETL pipeline with dbt or Airflow
- Looker Studio implementation
- Customer segmentation using RFM Analysis
- Customer Lifetime Value (CLV) Analysis

---

##  Author

**Dinesh Saliyary**

GitHub: https://github.com/dinesh0110

LinkedIn: https://linkedin.com/in/dineshsaliyar
