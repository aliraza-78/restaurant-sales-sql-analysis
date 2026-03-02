# Restaurant Sales & Demand Analysis Using Advanced SQL

## Project Overview

This project analyzes **21,350 restaurant transactions** totaling **817,860.05 in revenue** using MySQL.

The objective was to identify revenue drivers, seasonal demand patterns, product performance trends, and operational optimization opportunities through structured SQL analysis.

---

## Tools & Techniques

- MySQL  
- INNER JOIN  
- GROUP BY & Aggregations  
- CTE (WITH clause)  
- Window Functions (LAG, RANK, NTILE)  
- Revenue Growth Analysis  
- Pareto Analysis  

---

## Key Metrics

- **Total Revenue:** 817,860.05  
- **Total Orders:** 21,350  
- **Average Order Value:** 38.31  
- **Average Pizzas per Order:** 2.32  

---

## Key Insights

- Large pizzas generate **45.89% of total revenue**, making size the primary revenue driver.  
- Peak demand occurs between **12–1 PM** and **5–7 PM**.  
- Top 20% of pizzas contribute approximately **33% of total revenue**.  
- Revenue distribution across categories is balanced (23–27%).  
- Chicken-based pizzas consistently rank as monthly top performers.  

---

## Strategic Recommendations

1. Optimize staffing during peak lunch and dinner hours.  
2. Evaluate pricing adjustments for Large pizzas due to revenue dominance.  
3. Launch targeted promotions during September–October slowdowns.  
4. Prioritize high-performing chicken variants in marketing campaigns.  
5. Reassess operational necessity of XL and XXL sizes.  

---

## Repository Structure


restaurant-sales-sql-analysis/
│
├── analysis.sql
├── Restaurant_Sales_Report.pdf
└── dataset/

## How to Run This Project

1. Import the CSV files from the `dataset/` folder into MySQL.
2. Create tables matching the dataset schema.
3. Execute queries from `analysis.sql`.
4. Review results and insights in `Restaurant_Sales_SQL_Report.pdf`.
