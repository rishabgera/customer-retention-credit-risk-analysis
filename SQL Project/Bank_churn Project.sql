--1. What is the overall health of the customer base?
select count(*) as total_customers,
sum(exited) as churned_cust,
round(avg(balance),2) as avg_balance,
round(avg(credit_score),2) as avg_credit_score,
sum(exited)*100/count(*) || '%' as churn_rate
from banking

--2. Which Country Has Highest Churn?
select sum(exited)*100/count(*) as churn_rate,
sum(exited) as churned_cust,
country 
from banking
group by 3 
order by 2 desc
limit 1

--3. Age Group Churn Analysis
select case
	when age<25 then 'Under 25'
	when age between 25 and 50 then 'between 25-50'
	else 'over 50'
	end, 
sum(exited) as churned_customers,
sum(exited)*100/count(*) || '%' as churned_rate
from banking
group by 1 order by 2 desc

--4. High Balance Customers Leaving (how much money is at risk)
select 'Rs. ' || round(sum(balance)/10000000) || 'Cr' as total_money 
from banking
where exited =1

-- 5. Credit Score Vs Churn (Determine if low creditworthiness drives churn.)
SELECT CASE
        WHEN credit_score < 500 THEN 'Poor'
        WHEN credit_score < 700 THEN 'Average'
        ELSE 'Good'
    END AS credit_band,
    COUNT(*) customers,
    ROUND(100.0 * SUM(exited)/COUNT(*),2) churn_rate
FROM banking
GROUP BY 1
ORDER BY churn_rate DESC;.

--6. Credit card vs Churn rate (Determine whether credit card holders are more loyal)
SELECT case
	when hascr_card=1 then 'Has Credit Card'
	when hascr_card= 0 then	'No Credit Card'
    else 'Unknown'
    end,
COUNT(*) customers,
ROUND(100.0 * SUM(exited)/COUNT(*),2) churn_rate
FROM banking
GROUP BY 1;

--7.Active vs Inactive Members (Measure impact of engagement on retention.)
select case
	when is_active_member=1 then 'Active'
	when is_active_member=0 then 'Inactive'
	else 'Unknown'
	end,
	count(*) customers,
round(100.0 * SUM(exited)/COUNT(*),2) churn_rate
FROM banking
GROUP BY 1;

--8. Top 10 Highest Value Customers Who Churned (Useful for VIP customer recovery campaigns.)
select surname, customer_id,
sum(balance) as total_balance, 
sum(estimated_salary) as est_salary,
( sum(balance)+sum(estimated_salary)) as customer_value
from banking
where exited=1
group by 1,2
order by 3 desc
limit 10

--9. Identify top-10 value customers within each market(country)?
with value_cust as (select country, balance, 
rank() over (partition by country order by balance desc) as rnk
from banking)
select * from value_cust
where rnk<=10

--10.Revenue at Risk categorise based on balance
select case
	when balance >=100000 then 'High Balance'
	when balance >=50000 then 'Fair Balance'
	else 'Low balance'
	end,
count(*) as total_customers,
sum(exited) as Churned_customers,
sum(exited)*100/count(*) || '%' as Churn_rate,
round(Sum(balance)/10000000,1) || 'Cr' as total_balance
from banking
group by 1 order by 5 desc


--11. does tenure affect the churn rate? (Understand when customers are most likely to leave)
select tenure,
    COUNT(*) total_customers,
    ROUND(100.0 * SUM(exited)/COUNT(*),2) churn_rate
FROM banking
GROUP BY tenure
ORDER BY tenure;

--12. Which Customers Should Be Prioritized for Retention? (Balance lost by customer segment)
select case 
	when age<25 then 'young'
	when age between 25 and 50 then 'Middle Age'
	else 'Senior'
	end,
count(*) as Total_Customers,sum(exited) as churned_cust,
round(sum(case 
when exited=1 then balance else 0 end)/100000) || ' Lacs' as balance_lost,
round(sum(case when exited=1 then balance else 0 end)*100/sum(balance)) ||'%'
as revenue_at_risk
from banking
group by 1 order by 3 desc

--1. Which Customers Should Be Prioritized for Retention? (customer 
--retention prioritization model based risk scoring)
 select customer_id, 
 surname,
 estimated_salary,
 balance,
 age,
 (	case
 when estimated_salary>100000 then 2
 else 1
 end +
 case 
 when exited=1 then 3
 else 1
 end +
 	case
 when age>45 then 2
 else 1 end
 + 
 	case
 when balance >100000 then 2
 when balance<100000 then 1
 else 0
 end) as Risk_score
 from banking
	
	
	
	
	
	
	
	
	