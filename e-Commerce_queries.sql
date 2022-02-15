create schema ordersgl;
use ordersgl;

-- Drop the tables if they exist before use
drop table if exists Rating;
drop table if exists Orders;
drop table if exists ProductDetails;
drop table if exists Product;
drop table if exists Category;
drop table if exists Supplier;
drop table if exists Customer;

 -- Supplier(SUPP_ID,SUPP_NAME,SUPP_CITY,SUPP_PHONE)
create table Supplier( SUPP_ID int primary key,
					   SUPP_NAME varchar(20),
                       SUPP_CITY varchar(20),
                       SUPP_PHONE varchar(10));
                       
-- Customer(CUS__ID,CUS_NAME,CUS_PHONE,CUS_CITY,CUS_GENDER)
create table Customer( CUS_ID int primary key not null,
					   CUS_NAME varchar(20) null default null,
                       CUS_PHONE varchar(10),
                       CUS_CITY varchar(20),
                       CUS_GENDER char);
                       
-- Category(CAT_ID,CAT_NAME)
create table if not exists Category( CAT_ID int primary key not null,
					                 CAT_NAME varchar(20) null default null);
                       
-- Product(PRO_ID,PRO_NAME,PRO_DESC,CAT_ID)
create table if not exists Product( PRO_ID int primary key not null,
							        PRO_NAME varchar(20) null,
                                    PRO_DESC varchar(60) null,
                                    CAT_ID int not null,
                                    foreign key(CAT_ID) references Category(CAT_ID));
                                    
-- ProductDetails(PROD_ID,PRO_ID,SUPP_ID,PRICE)
create table if not exists ProductDetails( PROD_ID int primary key not null,
										   PRO_ID int not null,
                                           SUPP_ID int not null,
                                           PROD_PRICE int not null,
                                           foreign key(PRO_ID) references Product(PRO_ID));
                                           
-- Order(ORD_ID,ORD_AMOUNT,ORD_DATE,CUS_ID,PROD_ID)
create table if not exists Orders( ORD_ID int primary key not null,
								   ORD_AMOUNT int not null,
								   ORD_DATE date,
								   CUS_ID int not null,
                                   PROD_ID int not null,
                                   foreign key(CUS_ID) references Customer(CUS_ID),
								   foreign key(PROD_ID) references ProductDetails(PROD_ID));
                                  
-- Rating(RAT_ID,CUS_ID,SUPP_ID,RAT_RATSTARS)
create table if not exists Rating( RAT_ID int primary key not null,
								   CUS_ID int not null,
								   SUPP_ID int not null,
								   RAT_RATSTARS int not null,
                                   foreign key(CUS_ID) references Customer(CUS_ID),
								   foreign key(SUPP_ID) references Supplier(SUPP_ID));
                                   
                                   
-- Queries to Insert Data into above Tables
-- Date into Supplier Table
insert into Supplier values( 1, "Rajesh Retails", "Delhi", "1234567890"); 
insert into Supplier values( 2, "Appario Ltd.", "Mumbai", "2589631470"); 
insert into Supplier values( 3, "Knome products", "Banglore", "9785462315"); 
insert into Supplier values( 4, "Bansal Retails", "Kochi", "8975463285"); 
insert into Supplier values( 5, "Mittal Ltd.", "Lucknow", "7898456532"); 

-- Data into Customer Table
insert into Customer values( 1, "AAKASH", "9999999999", "DELHI", "M"); 
insert into Customer values( 2, "AMAN", "9785463215", "NOIDA", "M"); 
insert into Customer values( 3, "NEHA", "9999999999", "MUMBAI", "F"); 
insert into Customer values( 4, "MEGHA", "9994562399", "KOLKATA", "F"); 
insert into Customer values( 5, "PULKIT", "7895999999", "LUCKNOW", "M"); 

-- Data into Category Table
insert into Category values( 1, "BOOKS"); 
insert into Category values( 2, "GAMES");
insert into Category values( 3, "GROCERIES");
insert into Category values( 4, "ELECTRONICS");
insert into Category values( 5, "CLOTHES");

-- Data into Product Table
insert into Product values( 1, "GTA V", "DFJDJFDJFDJFDJFJF", 2); 
insert into Product values( 2, "TSHIRT", "DFDFJDFJDKFD", 5); 
insert into Product values( 3, "ROG LAPTOP", "DFNTTNTNTERND", 4); 
insert into Product values( 4, "OATS", "REURENTBTOTH", 3); 
insert into Product values( 5, "HARRY POTTER", "NBEMCTHTJTH", 1); 

-- Data into Product_Details Table
insert into ProductDetails values( 1, 1, 2, 1500);
insert into ProductDetails values( 2, 3, 5, 30000);
insert into ProductDetails values( 3, 5, 1, 3000);
insert into ProductDetails values( 4, 2, 3, 2500);
insert into ProductDetails values( 5, 4, 1, 1000); 

-- Data into Orders Table
insert into Orders values( 20, 1500, "2021-10-12", 3, 5); 
insert into Orders values( 25, 30500, "2021-09-16", 5, 2); 
insert into Orders values( 26, 2000, "2021-10-05", 1, 1); 
insert into Orders values( 30, 3500, "2021-08-16", 4, 3); 
insert into Orders values( 50, 2000, "2021-10-06", 2, 1); 

-- Data into Rating Table
insert into Rating values( 1, 2, 2, 4);
insert into Rating values( 2, 3, 4, 3);
insert into Rating values( 3, 5, 1, 5);
insert into Rating values( 4, 1, 3, 2);
insert into Rating values( 5, 4, 5, 4);

-- Write queries for the following:
-- Queries to fetch the required data from the tables
-- 3) Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
select c.CUS_GENDER, count(*) from Customer c inner join Orders o on c.CUS_ID = o.CUS_ID where o.ORD_AMOUNT >= 3000 group by c.CUS_GENDER;

-- 4) Display all the orders along with the product name ordered by a customer having Customer_Id=2.
select * from Orders o inner join ProductDetails pd on o.PROD_ID = pd.PROD_ID
inner join Product p on pd.PRO_ID =  p.PRO_ID where o.CUS_ID = 2;

-- 5) Display the Supplier details who can supply more than one product.
select * from Supplier where SUPP_ID IN 
(select SUPP_ID from ProductDetails group by SUPP_ID having count(*)> 1);

-- 6) Find the category of the product whose order amount is minimum.
select Category.* from Orders o inner join ProductDetails pd on o.PROD_ID = pd.PROD_ID
inner join Product p on pd.PRO_ID = p.PRO_ID inner join Category on p.CAT_ID = Category.CAT_ID order by o.ORD_AMOUNT limit 1;
-- Alternate Approach
select * from Category where CAT_ID = (select CAT_ID from Product where PRO_ID =
(select PRO_ID from ProductDetails where PROD_ID = 
(select PROD_ID from Orders where ORD_AMOUNT = 
(select min(ORD_AMOUNT) from Orders))));

-- a) Display the Id and Name of the Product ordered after “2021-10-05”.
select p.PRO_ID, p.PRO_NAME, p.PRO_DESC from Orders o inner join ProductDetails pd on o.PROD_ID = pd.PROD_ID
inner join Product p on pd.PRO_ID = p.PRO_ID where o.ORD_DATE > '2021-10-05';

-- 7) Display customer name and gender whose names start or end with character 'A'.
select CUS_NAME, CUS_GENDER from Customer where Customer.CUS_NAME like 'A%' or Customer.CUS_NAME like '%A';

-- 8) Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if 
-- rating >4 then “Genuine Supplier”  if rating >2 “Average Supplier” else “Supplier should not be considered”.

call categorize_supplier;
