-- find top 10 highest revenue generating products
Select Product_Id, SUM(Sale_Price) Total_Sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- find top 5 highest selling products in each region
WITH CTE AS(
SELECT Region , Product_Id, SUM(Sale_Price) AS Total_Sales
FROM orders
GROUP BY Region, Product_Id),
ranked_cte as(
Select *,
row_number()over(partition by region order by Total_Sales DESC) as rn
from CTE)
Select Region, Product_Id, Total_Sales
From ranked_cte
where rn<=5;

-- find month over month growth comparison for 2022 and 2023 sales
with cte as(
select year(Order_Date) Order_Year,Month(Order_Date) Order_Month,sum(Sale_Price) As Total_Sales
from orders
group by 1,2
		   )
SELECT Order_Month,
       SUM(Case when Order_Year=2022 then Total_Sales else 0 end) Sales_2022,
       SUM(Case when Order_Year=2023 then Total_Sales else 0 end) Sales_2023
FROM cte
GROUP BY Order_Month
ORDER BY Order_Month;     

-- for each category which month had highest sales 
with cte as(
Select Category,FORMAT(Order_Date, '%Y%m') AS Order_Year_Month,
Sum(Sale_Price) Total_Sale
From orders
group by 1,2
)
select * from(select *,
row_number()over(partition by Category order by Total_Sale Desc) as rn
from cte) A
Where rn=1;


-- which sub category had highest growth by profit in 2023 compare to 2022  
with cte as(
select Sub_Category,year(Order_Date) Order_Year,sum(Profit) As Profit
from orders
group by 1,2
		   ),
cte2 as(           
SELECT Sub_Category,
       SUM(Case when Order_Year=2022 then Profit else 0 end) Profit_2022,
       SUM(Case when Order_Year=2023 then Profit else 0 end) Profit_2023
FROM cte
GROUP BY 1)
Select *,
(Profit_2023-Profit_2022)*100/Profit_2022
from cte2
order by 2 Desc
Limit 1;