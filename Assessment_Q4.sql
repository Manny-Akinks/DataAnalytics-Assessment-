WITH CustomerTransactions AS (
    -- Calculate total transactions per customer
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) AS total_transaction_value  -- Add this line
    FROM
        adashi_staging.savings_savingsaccount s
    GROUP BY
        s.owner_id
),
CustomerTenure AS (
    -- Calculate account tenure in months
    SELECT
        u.id AS owner_id,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM
        adashi_staging.users_customuser u
)
SELECT
    ct.owner_id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    t.tenure_months,
    ct.total_transactions,
    ((ct.total_transactions / t.tenure_months) * 12 * (ct.total_transaction_value * 0.001)) AS estimated_clv -- Calculate CLV
FROM
    CustomerTransactions ct
JOIN
    CustomerTenure t ON ct.owner_id = t.owner_id
JOIN adashi_staging.users_customuser u ON ct.owner_id = u.id
ORDER BY
    estimated_clv DESC;
