##### **SQL Reservation Analytics Project**



###### **# Overview**



This project demonstrates analytical SQL work on a multi-year apartment reservation dataset.

The goal was to perform data quality validation, KPI computation, channel analysis, time analysis, and window-function based revenue concentration analysis.



All queries were written in PostgreSQL style SQL.



###### **# Dataset**



Table: reservations



**Columns include:**



* guest name
* check-in / check-out dates
* nights, persons
* booking channel (portal)
* price per night
* total revenue
* commission



Channel values were normalized in-query using CASE mapping.



###### **# Data Quality Checks**



Performed validation queries to detect:



* null values
* zero or negative nights
* invalid date ranges
* price inconsistencies
* duplicate bookings
* commission anomalies



###### **# KPI Analysis**



Computed core KPIs:



* bookings count
* total revenue
* net revenue
* nights and guests
* ADR
* average length of stay
* commission %



Used safe division with NULLIF to prevent division-by-zero errors.



###### **# Channel Analysis**



Normalized booking channels using CASE + pattern matching.



Per-channel metrics:



* revenue and net revenue
* ADR
* commission %
* revenue share %
* channel ranking



###### **# Time Analysis**



Time-based aggregations:



* monthly revenue trends
* seasonality detection
* yearly totals
* year-over-year % change (using window LAG)



Findings:



* strong summer seasonality
* July is peak month
* YoY trend is volatile (growth and decline periods)
* ADR increased until 2023, then declined



###### **# Window Function Analysis**



Used window functions for advanced analytics:



* guest revenue ranking
* running monthly revenue totals
* cumulative revenue share (Pareto analysis)
* monthly channel ranking



Findings:



* top guest revenue identified
* revenue not extremely concentrated (≈201 guests generate 80% of revenue)
* channel leadership varies by month



###### **# Skills Demonstrated**



* analytical SQL
* GROUP BY aggregations
* CASE normalization
* safe numeric calculations
* window functions (RANK, LAG, running SUM)
* time-based aggregation
* revenue concentration analysis



###### **# Purpose**



Portfolio project for Junior Data / BI Analyst roles demonstrating practical SQL analytics capability.

