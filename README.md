1. High-Value Customers with Multiple Products
 I first of all looked for primary and foreign keys that link all 3 tables, then i started to assess which table will give me each column in the expected output. The total deposit is generated from the confirmed_amount column. the savings and investment count are generated from is_a_fund and is_regular columns.

2. Transaction Frequency Analysis
I calculated the monthly transactions per customer.
I calculated the average monthly transactions.
I categorized the transaction frequency using case when clause
then I pulled all the cte's in the select statement.

3. Account Inactivity Alert
I grouped the activities in all accounts into savings and investment, then I found the latest day a transaction was made. 
I subtracted the curdate from the latest date.
I filtered by status_id and date difference being greater than 365 days.
the challenge here was ascertaining active accounts.


4. Customer Lifetime Value (CLV) Estimation

I calculated the total transactions per customer 
I calculated the account tenure in months
I brought them into a select statement then I calculated the estimated CLV, ordered descendingly.
