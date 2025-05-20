SELECT
    s.plan_id,
    s.owner_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE p.description  -- Default to original description if neither condition is met
    END AS type,
    (SELECT MAX(s2.transaction_date)
     FROM adashi_staging.savings_savingsaccount s2
     WHERE s2.owner_id = s.owner_id) AS last_transaction_date,
    DATEDIFF(CURDATE(), (SELECT MAX(s3.transaction_date)
                   FROM adashi_staging.savings_savingsaccount s3
                   WHERE s3.owner_id = s.owner_id)) AS inactivity_days
FROM
    adashi_staging.savings_savingsaccount s
JOIN
    adashi_staging.plans_plan p ON s.plan_id = p.id
WHERE
    p.status_id = 1
    AND s.owner_id NOT IN (
        SELECT DISTINCT s4.owner_id
        FROM adashi_staging.savings_savingsaccount s4
        WHERE s4.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 365 DAY)
    )
ORDER BY s.owner_id;
