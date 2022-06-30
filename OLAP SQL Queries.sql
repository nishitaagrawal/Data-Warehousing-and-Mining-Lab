1.	Obtain the total daily sales by book and subregion SUBREGION, DAY, ISBN, TITLE, TOTAL_SALES
select distinct
s.subregion_name as "subregion", d.day as "day",
d.num_day as "num_day",       	
p.isbn as "ISBN", p.title as "title",
sum(t.sell_by_product) as
"total_sales" from olap_bookshop.subregion s, olap_bookshop.day d, olap_bookshop.books p, olap_bookshop.facts_ticket t, olap_bookshop.warehouse where
t.warehouse_code = warehouse.code and warehouse.subregion_id = s.subregion_id and t.day_id = d.day_id and t.books_isbn = p.isbn group by s.subregion_name, d.day,
d.num_day, p.isbn
order by num_day asc; 


2.	Obtain annual sales per book YEAR, ISBN, TITLE, SALES_AMOUNT
select distinct an.year as "year", p.isbn as "isbn", p.title as "title",
sum(t.sell_by_product) as
"total_sales" from olap_bookshop.year an,
olap_bookshop.books p, olap_bookshop.facts_ticket t where
t.books_isbn= p.isbn group by
an.year, p.isbn order by p.isbn asc;  

                   	
3.	Obtain which region had the most transactions during October 2017 REGIONNAME, NO_TRANSACTIONS (ONE SINGLE  RENGLON, THE MAXIMUM)
with max_month as (select r.region_name,count(f.ticket_number)as count
from olap_bookshop.region r ,
olap_bookshop.facts_ticket f,
olap_bookshop.day d,
olap_bookshop.month m,
olap_bookshop.warehouse t,
olap_bookshop.subregion s
where
m.Month='october' and
f.Day_ID=d.Day_ID and
d.Month_ID=m.Month_ID and
f.Warehouse_code=t.Code and
t.Subregion_id=s.Subregion_ID and
s.Region_ID=r.Region_ID
group by r.Region_name)
select region_name,max(count) from max_month
group by region_name;


4.	Obtain the average of the sale per ticket (invoice) per month in each region REGIONAME, MONTH, AVG_INVOICE
select r.region_name, m.month,
avg(f.sell_by_product) from olap_bookshop.region r,
olap_bookshop.facts_ticket f, olap_bookshop.day d, olap_bookshop.month m, olap_bookshop.warehouse t, olap_bookshop.subregion s where
f.day_id = d.day_id and d.month_id=m.month_id and f.warehouse_code= t.code and t.subregion_id = s.subregion_id and s.region_id = r.region_id
group by
r.region_name, m.month
order by r.region_name;

5.	Get which books are bought together more frequently by OLAP (SQL)
a)	SQL (DESCRIPTIVE ANALYTICS)
with prod1 as ( select f.ticket_number, p.title
from olap_bookshop.books p, olap_bookshop.facts_ticket f where
p.isbn = f.books_isbn
group by f.ticket_number, p.title
)
select prod1.title, pr.title
from olap_bookshop.books pr, olap_bookshop.facts_ticket t, prod1 where t.ticket_number = prod1.ticket_number;

6.	Explain and execute four queries each one with dice, rollup, pivot, and slice
6.1	rollup command getting total sales region wise
 
select region.REGION_NAME as "region name",subregion.SUBREGION_NAME as "Subregion",
sum(facts_ticket.SELL_BY_PRODUCT) as "sales" from facts_ticket,region,subregion,warehouse
where region.REGION_ID = subregion.REGION_ID and subregion.SUBREGION_ID = warehouse.SUBREGION_ID and
warehouse.CODE = facts_ticket.WAREHOUSE_CODE group by  region.REGION_NAME,subregion.SUBREGION_NAME with rollup;


6.2	Slicing getting all the books and sales sold in month january
select region.region_name as "region-name",books.title as "title",month.month as "month",sum(facts_ticket.SELL_BY_PRODUCT) as "sales"
from region,warehouse,books,month,facts_ticket,subregion,day
where
region.REGION_ID = subregion.REGION_ID and subregion.SUBREGION_ID = warehouse.SUBREGION_ID and
books.isbn=facts_ticket.books_isbn and
warehouse.CODE = facts_ticket.WAREHOUSE_CODE and
month.month_id=day.month_id and
month.month="january"
group by region.region_name,books.title;


6.3	Dicing i.e getting sales amount of all the books sold in january and in asia
select region.REGION_NAME as "name",books.TITLE as "Book Name" ,month.month as "month",sum(facts_ticket.SELL_BY_PRODUCT) as "sales"
from region,warehouse,books,month,facts_ticket,subregion,day
where
region.REGION_ID = subregion.REGION_ID and subregion.SUBREGION_ID = warehouse.SUBREGION_ID and
books.isbn=facts_ticket.books_isbn and
warehouse.CODE = facts_ticket.WAREHOUSE_CODE and
month.month_id=day.month_id and
month.month="january" and region.REGION_NAME = "asia"
group by region.region_name,books.title order by sum(facts_ticket.SELL_BY_PRODUCT) ;


6.4	Pivoting i.e joining two different dimensions
select region.REGION_NAME as "name",books.TITLE as "Book Name" ,month.month as "month",sum(facts_ticket.SELL_BY_PRODUCT) as "sales"
from region,warehouse,books,month,facts_ticket,subregion,day
where
region.REGION_ID = subregion.REGION_ID and subregion.SUBREGION_ID = warehouse.SUBREGION_ID and
books.isbn=facts_ticket.books_isbn and
warehouse.CODE = facts_ticket.WAREHOUSE_CODE and
month.month_id=day.month_id
group by region.region_name,books.title,month.MONTH;
 
