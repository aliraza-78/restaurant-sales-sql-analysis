/* =========================================================
   RESTAURANT SALES & DEMAND ANALYSIS USING ADVANCED SQL
   Tool: MySQL 8+
   Dataset: Pizza Sales (Orders, Order_Details, Pizzas, Pizza_Types)
   ========================================================= */


/* =========================================================
   PHASE 1 — REVENUE FOUNDATION ANALYSIS
   ========================================================= */

-- 1. Total Revenue
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id;


-- 2. Total Orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- 3. Average Order Value (AOV)
SELECT 
    ROUND(
        SUM(od.quantity * p.price) 
        / COUNT(DISTINCT o.order_id), 
    2) AS avg_order_value
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id;


-- 4. Average Pizzas per Order
SELECT 
    ROUND(
        SUM(quantity) 
        / COUNT(DISTINCT order_id), 
    2) AS avg_pizzas_per_order
FROM order_details;



/* =========================================================
   PHASE 2 — TIME-BASED ANALYSIS
   ========================================================= */

-- 5. Monthly Revenue
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(od.quantity * p.price), 2) AS monthly_revenue
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
GROUP BY month
ORDER BY month;


-- 6. Month-over-Month Revenue Growth (Using LAG)
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(od.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_details od 
        ON o.order_id = od.order_id
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    GROUP BY month
)

SELECT 
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        LAG(revenue) OVER (ORDER BY month), 
    2) AS previous_month,
    ROUND(
        revenue - LAG(revenue) OVER (ORDER BY month), 
    2) AS revenue_change
FROM monthly_revenue;


-- 7. Revenue by Day of Week
SELECT 
    DAYNAME(o.order_date) AS day_name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
GROUP BY day_name
ORDER BY revenue DESC;


-- 8. Peak Order Hours
SELECT 
    HOUR(order_time) AS hour_of_day,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY hour_of_day
ORDER BY total_orders DESC;



/* =========================================================
   PHASE 3 — PRODUCT PERFORMANCE ANALYSIS
   ========================================================= */

-- 9. Top 10 Pizzas by Revenue
SELECT 
    pt.name AS pizza_name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 10;



-- 10. Revenue Concentration (Pareto Analysis using NTILE)
WITH pizza_revenue AS (
    SELECT 
        pt.name,
        SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt 
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name
)

SELECT 
    name,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100 * revenue 
        / SUM(revenue) OVER (), 
    2) AS revenue_percentage,
    NTILE(5) OVER (ORDER BY revenue DESC) AS revenue_group
FROM pizza_revenue
ORDER BY revenue DESC;


-- 11. Revenue by Category
SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    ROUND(
        100 * SUM(od.quantity * p.price)
        / SUM(SUM(od.quantity * p.price)) OVER (),
    2) AS revenue_percentage
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;


-- 12. Revenue by Size
SELECT 
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    ROUND(
        100 * SUM(od.quantity * p.price)
        / SUM(SUM(od.quantity * p.price)) OVER (),
    2) AS revenue_percentage
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY revenue DESC;



/* =========================================================
   PHASE 4 — ADVANCED ANALYSIS
   ========================================================= */

-- 13. Best-Selling Pizza Each Month (Using RANK)
WITH monthly_pizza_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        pt.name,
        SUM(od.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_details od 
        ON o.order_id = od.order_id
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt 
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY month, pt.name
)

SELECT *
FROM (
    SELECT 
        month,
        name,
        ROUND(revenue, 2) AS revenue,
        RANK() OVER (
            PARTITION BY month 
            ORDER BY revenue DESC
        ) AS rank_position
    FROM monthly_pizza_revenue
) ranked
WHERE rank_position = 1
ORDER BY month;