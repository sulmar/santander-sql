# santander-sql

~~~ sql

insert into #Orders values
('1', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski UNIVEGA ALPINA 27.5" 1 szt. 2200 zł'),
('2', 'Speed Cycles', 'ul. Rowerowa 31, 85-142 Bydgoszcz, Kujawsko-Pomorskie', '2020-02-12', 'Rower damski UNIVEGA GEO LIGHT NINE 1 szt. 4400 zł'),
('3', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski UNIVEGA ALPINA 1 27.5" szt. 2200 zł'),
('4', 'Trip Store', 'ul. Górska 12, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski Cube Attain Pro 28" 1 szt. 4200 zł'),
('5', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski Kona Rove ST, ultraviolet 28" 2 szt. 6700 zł'),
('6', 'Trip Store', 'ul. Górska 12, 01-242 Warszawa, Mazowieckie', '2020-04-23', 'Rower męski UNIVEGA ALPINA 4 szt. 2200 zł')

~~~

~~~ sql
insert into #Orders_1NF values
(1, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 1, 2200),
(2, 'Speed Cycles', 'ul. Rowerowa 31', '85-142', 'Bydgoszcz', 'Kujawsko-Pomorskie', '2020-02-12', 'Rower damski', 'UNIVEGA GEO LIGHT NINE', 28.0, 1, 4400),
(3, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 1, 2200),
(4, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'Cube Attain Pro', 28, 1,  4200),
(5, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'Kona Rove ST, ultraviolet', 28, 2, 6700),
(6, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-23', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 4, 2200)
~~~

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
(1, 1, '2020-04-05', 2200, 1.23, 2706),
(2, 2, '2020-02-12',4400, 1.23, 5412),
(3, 1, '2020-04-05', 2200, 1.23, 2706),
(4, 3, '2020-04-05', 4200, 1.23, 5166 ),
(5, 1, '2020-04-05', 13400, 1.23,  16483 ),
(6, 3, '2020-04-23', 2200, 1.23, 2706)


insert into #OrderDetails_2NF values
(1, 1, 2200, 1, 2200),
(2, 2, 4400, 1, 4400),
(3, 1, 2200, 1, 2200),
(4, 3, 4200, 1, 4200),
(5, 4, 6700, 2, 13400),
(6, 1, 2200, 4, 8800)

~~~
