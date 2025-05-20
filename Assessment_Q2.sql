WITH MonthlyTransactions AS (
    -- Calculate monthly transactions per customer
    SELECT
        s.owner_id,
        u.first_name,
        u.last_name,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,
        COUNT(*) AS monthly_transactions,
        SUM(s.confirmed_amount) AS monthly_total_amount  -- Added sum of confirmed_amount
    FROM
        adashi_staging.savings_savingsaccount s
    JOIN
        adashi_staging.users_customuser u ON s.owner_id = u.id
    GROUP BY
        s.owner_id,
        u.first_name,
        u.last_name,
        DATE_FORMAT(s.transaction_date, '%Y-%m')
),
AverageTransactions AS (
    -- Calculate average monthly transactions
    SELECT
        owner_id,
        first_name,
        last_name,
        AVG(monthly_transactions) AS avg_transactions,
        AVG(monthly_total_amount) AS avg_monthly_amount  -- Added average of monthly_total_amount
    FROM
        MonthlyTransactions
    GROUP BY
        owner_id,
        first_name,
        last_name
),
-- Categorize transaction frequency
TransactionFrequency AS (
    SELECT
        owner_id,
        first_name,
        last_name,
        avg_transactions,
        CASE
            WHEN avg_transactions >= 10 THEN 'High Frequency'
            WHEN avg_transactions >= 3 AND avg_transactions < 10 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS transaction_frequency,
        avg_monthly_amount
    FROM
        AverageTransactions
),
FrequencySummary AS (
    SELECT
        transaction_frequency,
        COUNT(*) AS customer_count,
        AVG(avg_transactions) AS avg_transactions_per_customer
    FROM
        TransactionFrequency
    GROUP BY
        transaction_frequency
)
SELECT 
    transaction_frequency,
    customer_count,
    ROUND(avg_transactions_per_customer, 2) AS avg_transactions_per_month
FROM FrequencySummary
ORDER BY 
    transaction_frequency;
