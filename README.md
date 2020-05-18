# SQL dla programistów .NET


## Normalizacja

### Przed normalizacją

~~~ sql

insert into #Orders values
('1', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski UNIVEGA ALPINA 27.5" 1 szt. 2200 zł'),
('2', 'Speed Cycles', 'ul. Rowerowa 31, 85-142 Bydgoszcz, Kujawsko-Pomorskie', '2020-02-12', 'Rower damski UNIVEGA GEO LIGHT NINE 1 szt. 4400 zł'),
('3', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski UNIVEGA ALPINA 1 27.5" szt. 2200 zł'),
('4', 'Trip Store', 'ul. Górska 12, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski Cube Attain Pro 28" 1 szt. 4200 zł'),
('5', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski Kona Rove ST, ultraviolet 28" 2 szt. 6700 zł'),
('6', 'Trip Store', 'ul. Górska 12, 01-242 Warszawa, Mazowieckie', '2020-04-23', 'Rower męski UNIVEGA ALPINA 4 szt. 2200 zł')

~~~

### 1 postać normalna - 1NF

tabela (encja) jest w pierwszej postaci normalnej 1NF kiedy:
- wiersz przechowuje informacje o pojedynczym obiekcie
- nie zawiera kolekcji
- posiada klucz główny (kolumnę lub grupę kolumn jednoznacznie identyfikujących go w zbiorze)
- dane są atomowe

~~~ sql
create table #Orders_1NF
(
	OrderId int,
	OrderNumber nvarchar(10),
	Customer nvarchar(100),
	[Street] nvarchar(100),
	[PostCode] char(6),
	[City] nvarchar(100),
	[Region] nvarchar(100),
	OrderDate datetime2,
	[ProductType] nvarchar(100),
	[ProductName] nvarchar(100),
	[Size] float,
	Quantity int,
	UnitPrice decimal
)
~~~

- Przykładowe dane
~~~ sql
insert into #Orders_1NF values
(1, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 1, 2200),
(2, 'Speed Cycles', 'ul. Rowerowa 31', '85-142', 'Bydgoszcz', 'Kujawsko-Pomorskie', '2020-02-12', 'Rower damski', 'UNIVEGA GEO LIGHT NINE', 28.0, 1, 4400),
(3, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 1, 2200),
(4, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'Cube Attain Pro', 28, 1,  4200),
(5, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'Kona Rove ST, ultraviolet', 28, 2, 6700),
(6, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-23', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 4, 2200)
~~~


### 2 postać normalna - 2NF

Każda tabela powinna przechowywać dane dotyczące tylko konkretnej klasy obiektów.

~~~ sql
create table #Customers_2NF 
(
	CustomerId int,
	[Street] nvarchar(100),
	Customer nvarchar(100),
	[PostCode] char(6),
	[City] nvarchar(100),
	[Region] nvarchar(100)
)


create table #ProductTypes_2NF
(
	ProductTypeId int, -- PK (Primary Key)
	[Name] nvarchar(100)
)

create table #Products_2NF (
	ProductId int, -- PK (Primary Key)
	ProductTypeId int, -- FK (Foreign Key)
	[ProductName] nvarchar(100),
	[Size] float,
	ListPrice decimal
)

create table #Orders_2NF (
	OrderId int,
	OrderNumber nvarchar(10),
	CustomerId int,	 -- FK
	OrderDate datetime2
)


create table #OrderDetails_2NF (
	OrderDetailId int, -- PK
	OrderId int, -- FK
	ProductId int, -- FK
	Quantity int,
	UnitPrice decimal

)

~~~

- Przykładowe dane
~~~ sql

insert into #Customers_2NF values
(1, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie'),
(2, 'Speed Cycles', 'ul. Rowerowa 31', '85-142', 'Bydgoszcz', 'Kujawsko-Pomorskie'),
(3, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie')


insert into #ProductTypes_2NF values
(1, 'Rower męski'),
(2, 'Rower damski')

insert into #Products_2NF values 
(1, 1, 'UNIVEGA ALPINA', 27.5, 2200),
(2, 2, 'UNIVEGA GEO LIGHT NINE', 28.0, 4400),
(3, 1, 'Cube Attain Pro', 28, 4200),
(4, 1, 'Kona Rove ST, ultraviolet', 28, 6700)


insert into #Orders_2NF values
(1, '1', 1, '2020-04-05'),
(2, '2', 2, '2020-02-12'),
(3, '3', 1, '2020-04-05'),
(4, '4', 3, '2020-04-05'),
(5, '5', 1, '2020-04-05' ),
(6, '6', 1, '2020-04-23')

insert into #OrderDetails_2NF values
(1, 1, 1, 1, 2200),
(2, 2, 2, 1, 4400),
(3, 1, 1, 1, 2200),
(4, 3, 3, 1, 4200),
(5, 4, 4, 2, 13400),
(6, 1, 5, 4, 8800)


~~~


### Group by i Union

~~~ sql
select 
	year(o.OrderDate) AS OrderYear,
	o.CustomerId,
	c.Customer,
	SUM(UnitPrice * Quantity) as Total,
	COUNT(*) as Number
 from #Orders_2NF as o
	inner join #OrderDetails_2NF as od
		on o.OrderId = od.OrderId
	inner join #Customers_2NF as c
		on c.CustomerId = o.CustomerId
group by
	YEAR(o.OrderDate), o.CustomerId, c.Customer

union all

select 
	year(o.OrderDate) AS OrderYear,
	null as CustomerId,
	null as Customer,
	SUM(UnitPrice * Quantity) as Total,
	COUNT(*) as Number
 from #Orders_2NF as o
	inner join #OrderDetails_2NF as od
		on o.OrderId = od.OrderId
	inner join #Customers_2NF as c
		on c.CustomerId = o.CustomerId
group by
	YEAR(o.OrderDate)

union all

select 
	null AS OrderYear,
	o.CustomerId,
	Customer,
	SUM(UnitPrice * Quantity) as Total,
	COUNT(*) as Number
 from #Orders_2NF as o
	inner join #OrderDetails_2NF as od
		on o.OrderId = od.OrderId
	inner join #Customers_2NF as c
		on c.CustomerId = o.CustomerId
group by
	o.CustomerId, Customer
~~~
