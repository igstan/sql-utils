-- Strongly inspired from here:
-- http://www.experts-exchange.com/Database/Miscellaneous/Q_24608444.html
SELECT
    COUNT(*) AS total,
    CASE
        WHEN age >= 35 THEN 35
        WHEN age >= 30 THEN 30
        WHEN age >= 25 THEN 25
        WHEN age >= 20 THEN 20
        ELSE 0
    END as age_interval
FROM (
    SELECT
        ROUND(DATEDIFF(CURRENT_DATE, date_of_birth) / 365) AS age
    FROM users
) AS birth_dates
GROUP BY age_interval;
