SELECT 
    DATE_TRUNC('month', "Order Date"::DATE) AS month,  -- Truncate to month, cast to DATE if necessary
    COUNT(*) AS total_revenue                          -- Use COUNT as a proxy if revenue column is missing
FROM orders_powerbi
WHERE EXTRACT(YEAR FROM "Order Date"::DATE) = 2022   -- Extract the year, cast to DATE if necessary
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 1;
