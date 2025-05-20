WITH CustomerSavingsPlans AS (
    SELECT
        s.owner_id
    FROM
        adashi_staging.savings_savingsaccount s
    JOIN
        adashi_staging.plans_plan p ON s.plan_id = p.id
    WHERE
        p.is_regular_savings = 1
        AND p.amount > 0
    GROUP BY
        s.owner_id
    HAVING
        COUNT(*) >= 1
),
CustomerInvestmentPlans AS (
    SELECT
        s.owner_id
    FROM
        adashi_staging.savings_savingsaccount s
    JOIN
        adashi_staging.plans_plan p ON s.plan_id = p.id
    WHERE
        p.is_a_fund = 1
        AND p.amount > 0
    GROUP BY
        s.owner_id
    HAVING
        COUNT(*) >= 1
),
CustomerDeposits AS (
    SELECT
        s.owner_id,
        SUM(s.confirmed_amount) AS total_deposits
    FROM
        adashi_staging.savings_savingsaccount s
    GROUP BY
        s.owner_id
),
CustomerPlanCounts AS (
    SELECT
        s.owner_id,
        SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
        SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count
    FROM
        adashi_staging.savings_savingsaccount s
    JOIN
        adashi_staging.plans_plan p ON s.plan_id = p.id
    GROUP BY
        s.owner_id
)
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    cpc.savings_count,
    cpc.investment_count,
    cd.total_deposits
FROM
    adashi_staging.users_customuser u
JOIN
    CustomerDeposits cd ON u.id = cd.owner_id
JOIN
    CustomerPlanCounts cpc ON u.id = cpc.owner_id
WHERE
    u.id IN (SELECT owner_id FROM CustomerSavingsPlans)
    AND u.id IN (SELECT owner_id FROM CustomerInvestmentPlans)
ORDER BY
    cd.total_deposits;
