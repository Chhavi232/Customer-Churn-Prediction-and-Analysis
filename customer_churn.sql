CREATE TABLE customer_churn (
    customerid VARCHAR(20),
    count INTEGER,
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(100),
    zip_code INTEGER,
    lat_long VARCHAR(50),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    gender VARCHAR(10),
    senior_citizen VARCHAR(10),
    partner VARCHAR(10),
    dependents VARCHAR(10),
    tenure_months INTEGER,
    phone_service VARCHAR(10),
    multiple_lines VARCHAR(30),
    internet_service VARCHAR(30),
    online_security VARCHAR(30),
    online_backup VARCHAR(30),
    device_protection VARCHAR(30),
    tech_support VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_movies VARCHAR(30),
    contract VARCHAR(30),
    paperless_billing VARCHAR(10),
    payment_method VARCHAR(50),
    monthly_charges NUMERIC(10,2),
    total_charges NUMERIC(10,2),
    churn_label VARCHAR(10),
    churn_value INTEGER,
    churn_score INTEGER,
    cltv INTEGER,
    churn_reason TEXT
);

select * from customer_churn
limit 30;

  --BASIC KPIs

-- Q1: Total customers
SELECT COUNT(*) FROM customer_churn;

-- Q2: Churn vs Non-Churn customers
SELECT churn_label, COUNT(*)
FROM customer_churn
GROUP BY churn_label;

-- Q3: Churn rate
SELECT 
ROUND(100.0 * SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)/COUNT(*),2)
AS churn_rate
FROM customer_churn;

-- Q4: Total monthly revenue
SELECT ROUND(SUM(monthly_charges),2)
FROM customer_churn;

-- Q5: Average monthly charges
SELECT ROUND(AVG(monthly_charges),2)
FROM customer_churn;

-- Q6: Total CLTV
SELECT SUM(cltv) FROM customer_churn;

  --CUSTOMER SEGMENTATION

-- Q7: Churn by gender
 SELECT gender,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY gender;

-- Q8: Churn by senior citizen
SELECT senior_citizen,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY senior_citizen;

-- Q9: Churn by partner status
SELECT partner,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY partner;

-- Q10: Churn by dependents
SELECT dependents,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY dependents;

-- Q11: Churn by phone service
SELECT phone_service,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY phone_service;

-- Q12: Churn by internet service
SELECT internet_service,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY internet_service;

-- Q13: Churn by streaming TV
SELECT streaming_tv,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY streaming_tv;

-- Q14: Churn by streaming movies
SELECT streaming_movies,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY streaming_movies;

  --CONTRACT AND PAYMENT

-- Q15: Churn by contract type
SELECT contract,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY contract;


-- Q16: Contract-wise churn rate
SELECT contract,
ROUND(100.0 * SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)/COUNT(*),2)
FROM customer_churn
GROUP BY contract;

-- Q17: Payment method vs churn
SELECT payment_method,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY payment_method;

-- Q18: Paperless billing impact
SELECT paperless_billing,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY paperless_billing;

-- Q19: Monthly charges vs churn
SELECT churn_label,
ROUND(AVG(monthly_charges),2)
from customer_churn
GROUP BY churn_label;

-- Q20: Total charges vs churn
SELECT churn_label,
ROUND(AVG(total_charges),2)
FROM customer_churn
GROUP BY churn_label;

  --TENURE ANALYSIS

-- Q21: Average tenure by churn
SELECT churn_label,
ROUND(AVG(tenure_months),2)
FROM customer_churn
GROUP BY churn_label;

-- Q22: Tenure buckets
SELECT
CASE
WHEN tenure_months<=12 THEN '0-1 YEAR'
WHEN tenure_months<=24 THEN '1-2 YEARS'
WHEN tenure_months<=48 THEN '2-4 YEARS'
ELSE '4+ YEARS'
END AS tenure_group,
COUNT(*),
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)
FROM customer_churn
GROUP BY tenure_group;

-- Q23: Short tenure churn risk
SELECT COUNT(*)
FROM customer_churn
WHERE tenure_months<=12 AND churn_label='Yes';

-- Q24: Long tenure customers churn
SELECT COUNT(*)
FROM customer_churn
WHERE tenure_months>48 AND churn_label='Yes';

-- Q25: Avg tenure distribution
SELECT MIN(tenure_months), MAX(tenure_months), AVG(tenure_months)
FROM customer_churn;

-- Q26: Top 10 high CLTV customers
SELECT customerid,cltv
FROM customer_churn
ORDER BY cltv DESC
LIMIT 10;

-- Q27: Average CLTV churn vs non-churn
SELECT churn_label,
ROUND(AVG(cltv),2)
FROM customer_churn
GROUP BY churn_label;

-- Q28: Revenue lost due to churn
SELECT ROUND(SUM(monthly_charges),2)
FROM customer_churn
WHERE churn_label='Yes';

-- Q29: High risk customers (high charges + low tenure)
SELECT COUNT(*)
FROM customer_churn
WHERE monthly_charges >
(
    SELECT AVG(monthly_charges)
    FROM customer_churn
)
AND tenure_months < 12;

-- Q30: High value churn customers
SELECT COUNT(*)
FROM customer_churn
WHERE cltv >
(
    SELECT AVG(cltv)
    FROM customer_churn
)
AND churn_label = 'Yes';

-- Q31: Rank customers by CLTV
SELECT customerid,cltv,
RANK() OVER(ORDER BY cltv DESC) AS cltv_rank
FROM customer_churn;

-- Q32: Top 5 high value customers
SELECT * 
FROM(
SELECT customerid,cltv,
RANK() OVER(ORDER BY cltv desc) AS rnk
from customer_churn
)t
WHERE rnk<=5;

-- Q33: Rank customers by monthly charges
SELECT customerid,monthly_charges,
RANK() OVER (ORDER BY monthly_charges DESC) AS charge_rank
FROM customer_churn;

-- Q34:Running total of revenue
SELECT customerid,monthly_charges,
SUM(monthly_charges) OVER (ORDER BY customerid) AS running_revenue
FROM customer_churn;

-- Q35: Churn rate by contract with ranking
SELECT contract,
ROUND(100.0 * SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS churn_rate,
RANK() OVER (
    ORDER BY 
    ROUND(100.0 * SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)/COUNT(*),2)
    DESC
) AS churn_rank
FROM customer_churn
GROUP BY contract;

-- Q36: Full business summary
SELECT 
COUNT(*) AS total_customers,
SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END) AS churned,
ROUND(100.0 * SUM(CASE WHEN churn_label='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS churn_rate,
ROUND(SUM(monthly_charges),2) AS revenue
FROM customer_churn;

-- Q37: Key insight - risk segmentation
SELECT
CASE
WHEN churn_label='Yes' AND tenure_months<=12 Then 'HIGH RISK'
WHEN churn_label='Yes' Then 'AT RISK'
ELSE 'STABLE'
END AS customer_segment,
COUNT(*)
FROM customer_churn
group by customer_segment;











