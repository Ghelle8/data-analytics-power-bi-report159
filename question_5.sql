-- Query to find the product category with the most profit in Wiltshire, UK for 2021
SELECT 
    p.category AS product_category,
    SUM(
        (op."Product Quantity" * p.sale_price) - (op."Product Quantity" * p.cost_price)
    ) AS total_profit
FROM 
    orders_powerbi op
JOIN 
    dim_products p
    ON op."product_code" = p."product_code"
JOIN 
    dim_stores ds
    ON op."Store Code" = ds."store code"
WHERE 
    ds.country_region = 'Wiltshire' 
    AND ds.country_code = 'GB'
    AND EXTRACT(YEAR FROM TO_DATE(op."Order Date", 'YYYY-MM-DD')) = 2021
GROUP BY 
    p.category
ORDER BY 
    total_profit DESC
LIMIT 1;
