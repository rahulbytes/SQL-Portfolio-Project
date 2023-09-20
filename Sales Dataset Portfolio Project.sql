--1) What is the Total Sales by each Category?
Select Category, sum(sales) as Sales from order_details
group by category
order by sum(sales) desc;

--2) What is the Profit earned from each category?
Select Category, sum(profit) as Profit from order_details
group by category
order by 2 desc;

--3) What is the Qunatity Sold in each category?
Select category, sum(quantity) as Quantity from order_details
group by category
order by 2 desc;

--4) Number of orders we got from each category?
Select a.category, count(distinct b.order_id) from order_details a 
join list_of_orders b on b.order_id = a.order_id
group by 1
order by 2 desc;

--5) Who are our top 5 most spending customers?
Select a.customername, sum(b.sales) as Sales from list_OF_orders a
join order_details b on b.order_id = a.order_id
group by 1
order by 2 desc
limit 5;

--6) Which State have the Highest Number and amount of orders coming from?
Select a.state, count(distinct b.order_id) as No_of_orders, sum(b.sales) as Sales from list_of_orders a 
join order_details b on b.order_id = a.order_id
group by 1
order by 3 desc

--7) Which City have the Highest Number and amount of orders coming from?
Select a.city, count(distinct b.order_id) as No_of_orders, sum(b.sales) as Sales from list_of_orders a 
join order_details b on b.order_id = a.order_id
group by 1
order by 3 desc

--8) What is our sales by each month?
Select a.month, sum(b.sales) as Sales from list_OF_orders a
join order_details b on b.order_id = a.order_id 
Group by 1 
order by  min(a.order_date);

--9) Which sub_category have the highest sales?
Select sub_category, sum(sales) as sales from order_details 
group by 1
order by 2 desc

--10) Which Sub-category is making the most amount of sales with their profits from each category?
with my_cte as
(Select category, sub_category, sum(sales)as sales, sum(profit) as profit,
 rank() over(partition by category order by sum(sales) desc) as Rank
 from order_details
 group by 1,2
)
Select category, sub_category, Sales, Profit
from my_cte
where Rank = 1 

--11) Which sub_category is most famous in each state?
With my_cte as (Select a.state as State,
				b.sub_category as Sub_Category,
				sum(b.quantity) as No_Orders,
				rank() over(partition by a.State order by sum(b.quantity)desc) as Rank
from list_of_orders a 
Join order_details b on b.order_id = a.order_id 
group by 1,2
)
Select State, sub_category, No_Orders from my_cte 
where Rank = 1
order by 3 desc;

--12) What is the Percentage of Profit we are getiing from each state?
With my_cte as 
(Select a.state, sum(b.profit) as Profit, sum(b.sales) as Sales from list_of_orders a
join order_details b on b.order_id = a.order_id
Group by 1
),

total_cte as
(select sum(profit) as Profit from my_cte) 
 
Select m.State, m.profit, m.sales, 
Concat(Round((m.Profit/ t.profit )*100,2),'%') as Profit_Percentage 
from my_cte as m
cross join total_cte as t
order by 2  desc

--13) What is the Average Profit Margin(%) for each Category?
With my_cte as (
	Select Category, Sum(Sales) as Sales, Sum(Profit) as Profit,
	(Sum(Sales)-Sum(Profit)) as Cost 
	from order_details 
group by 1
	)
	Select Category, Sum(Sales)as Sales,sum(Profit)as Profit, 
	CONCAT(Round(Sum(Profit)/Sum(cost)*100,2),'%')as profit_Margin from my_cte
	group by 1;

--14) What is the distribution of orders from every city according to category?
Select
    l.City,
    Sum(CASE WHEN od.Category = 'Furniture' THEN 1 ELSE 0 END) AS Furniture_Orders,
    Sum(CASE WHEN od.Category = 'Clothing' THEN 1 ELSE 0 END) AS Clothing_Orders,
	Sum(CASE WHEN od.Category = 'Electronics' THEN 1 ELSE 0 END) AS Electronics_Orders,
	COUNT(*) AS Total_Orders
	FROM List_of_orders l
JOIN Order_details od ON l.order_id = od.order_id
GROUP BY l.City
ORDER BY total_orders desc;

--15) Which Sub_category is most sold in each month?
With my_cte as 
(Select a.month, b.sub_category, sum(b.quantity) as Quantity,
 Rank() over(Partition by a.month order by sum(b.quantity) desc) as Rank
 from list_of_orders a 
 join order_details b on b.order_id = a.order_id 
 group by 1,2
 )
Select Month, sub_category, Quantity FROM MY_CTE 
where Rank = 1 
group by 1,2,3
order by 3 desc

	 





