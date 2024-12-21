-- Q1) RETRIVE THE TOTAL NUMBER OF ORDERS PLACED  
SELECT COUNT(order_id) total_orders from orders;

-- Q2)CALCULATE TOTAL REVENUE GENERATED FROM PIZZA SALES
select  
round(sum(order_details.quantity*pizzas.price),2) as total_Sal
from order_details join pizzas
on pizzas.pizza_id=order_details.pizza_id; 

-- Q3) IDENTIFY THE HIGHESTT PRICE PIZZA
select *
from pizzas
where price=(Select max(price)
from pizzas);

-- another way

select pizza_types.name,pizzas.price
from pizza_types inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by price desc limit 1;

-- Q4) IDENTIFY MOST COMMON PIZZA SIZE ORDERED.

select pizzas.size,count(order_details.quantity) as most_ordered
from pizzas inner join order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size
order by most_ordered desc limit 1;

-- Q5)LIST TOP 5 MOST ORDERED PIZZAS WITH THEIR QUANTITIES

select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
inner join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by quantity desc limit 5;

-- Q6)JOIN NECCESSARY TABLES TO FIND THE TOTAL QUANTITY OF EACH PIZZA CATEGORY ORDERED.

select pizza_types.category,
sum(order_details.quantity) as quantity
from pizza_types inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
inner join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by quantity desc;

-- Q7)DETERMINE DISTRIBUTION OF ORDERS BY HOUR OF THE DAY
select hour(order_time),count(order_Id) as order_count
from orders
group by hour(order_time)
order by order_count desc;


-- Q8)JOIN RELEVANT TABLES TO FIND THE CATEGORY WISE DISTRIBUTION OF PIZZAS
select category, count(name)
from pizza_types
group by category;

-- Q9) GROUP THE ORDERS BY DATE AND CALCULATE THE AVERAGE NUMBER OF PIZZAS ORDERED PER DAY

select round(avg(quantities),2) as avg_quantity from
(select orders.order_date,sum(order_details.quantity) as quantities
from orders inner join order_details
on orders.order_Id=order_details.order_Id
group by orders.order_date) order_quantity;


-- Q10) Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc  limit 3;

-- Q11) Calculate the percentage contribution of each pizza type to total revenue.

 select pizza_types.category,
(sum(order_details.quantity*pizzas.price) /(select  
round(sum(order_details.quantity*pizzas.price),2) as total_Sal
from order_details join pizzas
on pizzas.pizza_id=order_details.pizza_id))*100 as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc;

 -- Q12 Analyze the cumulative revenue generated over time.
select order_date,
sum(revenue) over(order by order_date) as cm_rev
from  
(select orders.order_date,
sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_Id = order_details.order_Id
group by orders.order_date) as sales;

-- Q13) Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name,revenue from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category,pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category,pizza_types.name ) as a) as b
where rn<=3;


