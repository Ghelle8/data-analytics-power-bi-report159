SELECT SUM(CAST("staff numbers" AS INTEGER)) AS total_staff
FROM dim_stores
WHERE "country_code" = 'GB'
AND "staff numbers" IS NOT NULL;


