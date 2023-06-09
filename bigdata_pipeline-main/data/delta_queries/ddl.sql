create schema delta.inventory with (location='s3a://warehouse/delta/inventory');

create table delta.inventory.customers (
	id integer, 
	first_name varchar, 
	last_name varchar, 
	email varchar, 
	op varchar,
	curr_timestamp TIMESTAMP(3) WITH TIME ZONE
) with (location='s3a://warehouse/delta/inventory/customers');

create table delta.inventory.orders(
	order_number integer, 
	order_date integer, 
	purchaser integer, 
	quantity integer, 
	product_id integer,
	op varchar,
	curr_timestamp TIMESTAMP(3) WITH TIME ZONE
) with (location='s3a://warehouse/delta/inventory/orders');

create table delta.inventory.products(
	id integer, 
	name varchar, 
	description varchar, 
	weight double, 
	op varchar,
	curr_timestamp TIMESTAMP(3) WITH TIME ZONE
) with (location='s3a://warehouse/delta/inventory/products');

show tables from delta.inventory;

select * from delta.inventory.customers;
select * from delta.inventory.orders;
select * from delta.inventory.products;


--drop table delta.inventory.customers;
--drop table delta.inventory.orders;
--drop table delta.inventory.products;
