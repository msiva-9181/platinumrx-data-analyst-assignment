SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

WITH revenue AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
expenses_data AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT 
    r.month,
    r.total_revenue,
    COALESCE(e.total_expense, 0) AS total_expense,
    (r.total_revenue - COALESCE(e.total_expense, 0)) AS profit,
    CASE 
        WHEN (r.total_revenue - COALESCE(e.total_expense, 0)) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM revenue r
LEFT JOIN expenses_data e ON r.month = e.month;

WITH clinic_profit AS (
    SELECT 
        c.city,
        cs.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e 
        ON cs.cid = e.cid 
        AND MONTH(e.datetime) = MONTH(cs.datetime)
    WHERE MONTH(cs.datetime) = 10
    GROUP BY c.city, cs.cid
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT *
FROM ranked
WHERE rnk = 1;

WITH clinic_profit AS (
    SELECT 
        c.state,
        cs.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e 
        ON cs.cid = e.cid 
        AND MONTH(e.datetime) = MONTH(cs.datetime)
    WHERE MONTH(cs.datetime) = 10
    GROUP BY c.state, cs.cid
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT *
FROM ranked
WHERE rnk = 2;
