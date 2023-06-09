create schema memory.inventory;

create table if not exists memory.inventory.custome_product_order(
	first_name varchar,
	last_name varchar,
	order_date integer,
	quantity integer,
	product_name varchar,
	product_description varchar,
	product_weight double
);

insert into memory.inventory.custome_product_order
select
	c.first_name,
	c.last_name,
	o.order_date,
	o.quantity,
	p.name,
	p.description,
	p.weight
from delta.inventory.customers c
inner join delta.inventory.orders o
on c.id = o.purchaser
inner join delta.inventory.products p 
on p.id = o.product_id;

select * from memory.inventory.custome_product_order;

