CREATE VIEW store_type_summary AS
WITH total_sales_summary AS (
    SELECT
        store_type,
        SUM(total_sales) AS total_sales,
        COUNT(*) AS orders_count
    FROM store_sales_summary
    GROUP BY store_type
),
overall_totals AS (
    SELECT
        SUM(total_sales) AS total_sales
    FROM store_sales_summary
)
SELECT
    t.store_type,
    t.total_sales,
    (t.total_sales / o.total_sales) * 100 AS pct_total_sales,
    t.orders_count
FROM total_sales_summary t
JOIN overall_totals o
ON true;
