-- Query to find the German store type with the highest revenue for 2022
SELECT
    ds.store_type,
    SUM(ss.total_sales) AS total_revenue
FROM store_sales_summary ss
JOIN dim_stores ds
    ON ds.store_type = ss.store_type  -- Join on store_type
WHERE ds.country_code = 'DE'  -- Filter for Germany
  AND ds.date_opened BETWEEN '2022-01-01' AND '2022-12-31'  -- Adjust if date_opened is in dim_stores
GROUP BY ds.store_type
ORDER BY total_revenue DESC
LIMIT 1;
