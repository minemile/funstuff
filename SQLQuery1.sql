-------------------------------------------------------------------------------------------------------------------------
------------------------------------1-АЯ ЧАСТь---------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-----------------------Товары--------------------------------------------
USE URFU_MOBILE;
IF exists(select * from sys.objects
						where object_id=OBJECT_ID(N'[Goods]'))
DROP TABLE [Goods]
GO
create table Goods(
	id_goods int not null primary key identity(1,2),
	code_goods char(15) not null,
	name_goods varchar(25) not null,
	[description] nvarchar(1000),
	start_time smalldatetime not null
)
-----------------------Магазины----------------------------------------
IF exists(select * from sys.objects
						where object_id=OBJECT_ID(N'[Shop]'))
DROP TABLE [Shop]
GO
create table Shop(
	code_shop char(5) primary key,
	name_shop varchar(50) not null unique,
	telephone varchar(25),
	[address] nvarchar(500),
	--constraint chk_telephone check(telephone not like '%[^-0-9+*#() ]%' )
)
---------------------Расписание магазинов---------------------------
IF exists(select * from sys.objects
						where object_id=OBJECT_ID(N'[Schedule]'))
DROP TABLE [Schedule]
GO
create table Schedule(
	code_shop char(5) not null references Shop(code_shop),
	day_week tinyint not null  check(day_week between 1 and 7),
	start_work_hour tinyint not null check(start_work_hour between 0 and 23),
	start_work_minute tinyint not null check(start_work_minute between 0 and 59),
	end_work_hour tinyint not null check(end_work_hour between 0 and 23),
	end_work_minute tinyint not null check(end_work_minute between 0 and 59),
	break_time bit not null default (0),
	constraint pk_Schedule primary key (code_shop, day_week),

)
-----------Реестр покупок------------------------------------------
IF exists(select * from sys.objects
						where object_id=OBJECT_ID(N'[Buy]'))
DROP TABLE [Buy]
GO
create table Buy(
	id_buy bigint not null primary key identity(1,1),
	code_shop char(5) not null references Shop(code_shop),
	datetime_buy datetime not null,
	id_goods int not null references Goods(id_goods),
	count_buy smallint not null,
	price smallmoney not null,
	discount decimal(4,2),
	buyer varchar(100)
)


-------------------------------------------------------------------------------------------------------------------------
------------------------------------2-АЯ ЧАСТь---------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
INSERT Shop(code_shop,name_shop,telephone,[address])
	VALUES('1','Prostore','+7-912-454-33-22','Екатеринбург,ул.Ленина,д.45'),
			('2','MEGA','+7-343-345-3344','Екатеринбург,ул.Малышева,д.143')
GO
select * from Shop
--2.2.	Введите расписание магазинов: один из них работает с выходными и с перерывом в будние дни, второй – с выходными, но без перерывов.
INSERT Schedule(code_shop,day_week,start_work_hour,start_work_minute,end_work_hour,end_work_minute,break_time)
	VALUES('1',1,10,00,22,00,1),
		  ('1',2,10,00,22,00,1),
		  ('1',3,10,00,21,00,1),
		  ('1',4,11,00,22,00,1),
		  ('1',5,11,30,21,30,1),
		  ('2',1,11,00,22,00,0),
		  ('2',2,11,00,22,00,0),
		  ('2',4,11,00,21,00,0),
		  ('2',5,11,00,22,00,0),
		  ('2',6,11,30,20,30,0)
GO
select * from Schedule
--3.	Введите 5-10 товаров
INSERT Goods(code_goods,name_goods,description,start_time)
	VALUES('000001','Жакет','Весенный, кожа',convert(datetime,'2015-04-30 11:22:33',120)),
		('000002','Jeans','раз.34, женский',convert(datetime,'2015-01-20 21:12:23',120)),
		('000003','Брюки','зимние, для спорта, р.44',convert(datetime,'2015-01-31 10:02:34',120)),
		('000004','Сапоги', 'Весенные, р.36, полусапоги, коричневые',convert(datetime,'2015-03-02 22:12:54',120)),
		('000005','Платье ','летное , с принтом солнца ',convert(datetime,'2015-11-30 16:12:32',120)),
		('000006','Рубашка','старая , фирма:Гучи ',convert(datetime,'2015-12-31 12:12:33',120)),
		('000007','Браслет','каменные ',convert(datetime,'2015-05-20 15:26:25',120))
		  
GO
select * from Goods
--4.4.	Введите 20-30 покупок. Должно быть хотя бы по одной покупке в каждый месяц 2010 года. 
insert Buy(code_shop,datetime_buy,id_goods,count_buy,price,discount,buyer)
	values ('1', convert(datetime,'2011-02-3',120),7,1,90000,null,'Сергеевна С.'), 
	('1', convert(datetime,'2010-02-3',120),1,1,20000,null,'Сергеевна С.'), 
	('1', convert(datetime,'2010-05-3',120),11,1,2000,30,'Сергеевна С.'), 
	('1', convert(datetime,'2010-02-23',120),7,1,1000,90,'Сергеевна С.'), 
	('1', convert(datetime,'2010-02-13',120),3,1,9000,11,'Сергеевна С.'), 
	('1', convert(datetime,'2011-02-3',120),5,1,90000,null,'Сергеевна С.'), 
	('1', convert(datetime,'2010-12-03',120),1,1,3000,5,'Peter Fan'),
	('1', convert(datetime,'2010-12-12',120),3,1,1800,null,'Иванов Иван Иванович'),
	('1', convert(datetime,'2010-03-29',120),5,1,5000,50,'Anna sui'),
	('2', convert(datetime,'2010-04-28',120),7,1,49100,25,'Михиал П.О.'),
	('1', convert(datetime,'2010-05-27',120),13,1,1000,60,'Иванов'),
	('1', convert(datetime,'2010-06-14',120),15,1,800,60,'Алэх Г.Д.'),
	('1', convert(datetime,'2010-11-30',120),17,2,3000,80,'Киреева Инна'),
	('1', convert(datetime,'2010-08-24',120),13,3,800,null,'Александр Ф.Б.'),
	('2', convert(datetime,'2010-08-24',120),11,1,6000,25,'Морозов О.О.'),
	('2', convert(datetime,'2010-07-24',120),11,1,6000,null,'Морозов'),
	('1', convert(datetime,'2010-09-23',120),9,1,8000,60,'Аверин Максим Игоревич'),
	('1', convert(datetime,'2010-10-22',120),5,1,5000,50,'Капаева Л.'),
	('2', convert(datetime,'2010-02-21',120),13,1,1800,65,'Бодрый Дмитрий'),
	('2', convert(datetime,'2010-12-20',120),7,1,4900,30,'Сергеев С.С.'),
	('2', convert(datetime,'2010-12-20',120),11,5,8600,null,'Ирина Б.Ф.'),
	('1', convert(datetime,'2015-08-18',120),11,2,8200,null,'Тапавев Р.Р.'),
	('1', convert(datetime,'2010-09-17',120),11,1,9000,null,'Сорвина М.'),
	('2', convert(datetime,'2015-10-16',120),5,1,6000,12,'Гаврилов'),
	('1', convert(datetime,'2013-11-15',120),19,1,8000,null,'Сергеев Сергей Сергеевич'),
	('2', convert(datetime,'2014-02-14',120),5,5,1800,null,'Сорвин Маским'),
	('2', convert(datetime,'2012-12-13',120),5,1,5000,null,'Грачев К.'),
	('1', convert(datetime,'2013-11-12',120),11,1,86000,null,'Свиридов А.Р.'),
	('2', convert(datetime,'2010-11-12',120),11,1,8000,30,'Свиридов А.'),
	('2', convert(datetime,'2010-11-12',120),7,1,8000,null,'Свиридов Андрей'),
	('1', convert(datetime,'2010-05-25',120),11,1,3000,null,'Лушко Ирина'),
	('2', convert(datetime,'2010-12-9',120),13,1,1200,null,'Ганиев Р.И.'),
	('1', convert(datetime,'2010-01-6',120),13,1,6000,5,'Павлов Павел Павлович'),
	('1', convert(datetime,'2010-02-3',120),7,1,4900,null,'Сергеев С.')
	

Select * from Buy


-------------------------------------------------------------------------------------------------------------------------
------------------------------------3-АЯ ЧАСТь---------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--1.	Напишите запрос, который выберет из реестра покупок  все покупки, 
--совершенные ранее 01.08.2010. 
--Запрос должен вернуть все поля из реестра покупок.
SELECT * FROM Buy b
	where b.datetime_buy<'20100801 00:00:00'

-- 2.	Напишите запрос, который вернет покупки, 
--совершенные в первом магазине в декабре  2010 года. 
--Запрос должен вернуть следующую информацию: наименование товара, 
--дату и время покупки, ФИО покупателя, кол-во проданного товара.

select g.name_goods,p.datetime_buy,p.buyer,p.count_buy from Buy p
		join Goods g on g.id_goods=p.id_goods
	where code_shop='1' and datetime_buy between convert(datetime,'2010-12-01',120) and convert(datetime,'2010-12-31',120)

--3.	Напишите запрос, который выводит среднюю скидку, максимальную и минимальную цену товаров. 
--Результат запроса должен содержать идентификатор товара, наименование товара, среднюю скидку, 
--минимальную и максимальную цену товара. Отсортировать результат по наименованию товара.
select g.id_goods,g.name_goods,avg(p.discount) as Average_discount,
		min(p.price) as Min_price,max(p.price) as Max_price from Buy p
			join Goods g on g.id_goods=p.id_goods
			group by g.id_goods,g.name_goods
			order by g.name_goods

--4. 	Напишите запрос, который вернёт для каждого магазина суммарно кол-во часов и минут, которые он работает в неделю.
-- Результат запроса: наименование магазина, кол-во целых часов работы, кол-во минут работы
-- (от 0 до 59, т.е. остаток от целых часов).
select s.name_shop as Shop_name,
	(sum(case when(t.end_work_hour>=t.start_work_hour) then ((t.end_work_hour-start_work_hour)*60+
	(t.end_work_minute-t.start_work_minute))
	else((24-t.start_work_hour+t.end_work_hour)*60+(t.end_work_minute-t.start_work_minute))
	end))/60 as Work_hours,
	(sum(case when(t.end_work_minute>=t.start_work_minute) then ((t.end_work_hour-start_work_hour)*60+
	(t.end_work_minute-t.start_work_minute))
	else((t.end_work_hour-t.start_work_hour-1)*60+(t.end_work_minute-t.start_work_minute))
	end))%60 as Work_minutes 
		from Shop s join Schedule t
					on s.code_shop=t.code_shop
				group by s.name_shop

-----------------------------------------------------------------------------------------------------
-----------------------------4АЯ ЧАСТь---------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--1.	Напишите хранимую процедуру, которая вернёт все покупки для товаров с определенной подстрокой в наименовании.
-- Запрос должен вернуть следующие поля: Наименование магазина, Идентификатор покупки, Покупатель, Наименование товара,
-- Сумма покупки (Кол-во товара * Цена ед. товара * (100% - Скидка)). 
--Подстрока поиска – входной параметр хранимой процедуры.
if exists (select * from sysobjects 
                  where id = object_id(N'Procedure4_1')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure Procedure4_1
go
create procedure Procedure4_1 @namegoods varchar(25)
as
	select s.name_shop,b.id_buy,b.buyer,g.name_goods,
		(case when(b.discount is null) then (b.count_buy*b.price)
			else(b.count_buy*b.price*((100-b.discount)/100))
		end) as Sum_Cost
		from Buy b
			left join Shop s on s.code_shop=b.code_shop
			left join Goods g on b.id_goods=g.id_goods
		where g.name_goods like '%'+@namegoods+'%'
go
execute Procedure4_1 @namegoods='Jeans'


--2.Напишите хранимую процедуру, которая выводит суммы покупок и
-- среднюю цену товаров за указанный период. 
--Товары, которые ни разу не продавались (в рамках указанного периода),
-- НЕ ДОЛЖНЫ присутствовать в результате запроса. 
--Входные параметры процедуры: начало периода, конец периода. 
--Результат запроса должен содержать наименование товара, сумму покупок и среднюю цену.
if exists (select * from sysobjects 
                  where id = object_id(N'Procedure4_2')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure Procedure4_2
go
create procedure Procedure4_2 @start datetime, @end datetime
as
	select g.name_goods,
			sum(case when(b.discount is null) then(b.count_buy*b.price)
					else(b.count_buy*b.price*(100-b.discount)/100)end) as Sum_buy,
			avg(b.price) as Average_price
		from Buy b
			 join Goods g on b.id_goods=g.id_goods
		where b.datetime_buy>=@start and b.datetime_buy<=@end
		group by g.name_goods
go
execute Procedure4_2 @start='20100130 00:00:00' , @end='20100530 00:00:00' 

--3.	Напишите хранимую процедуру, выводящую список магазинов, 
--в которых продаётся указанный товар и при этом количество сделок по покупке этого товара БОЛЕЕ определенного значения.
-- Сделка по покупки товара – один факт покупки данного товара вне зависимости от того, 
--сколько было приобретено товара при данной сделке. Входные параметры хранимой процедуры: 
--идентификатор товара, пороговое значение количества сделок. Результат запроса должен содержать: 
--наименование магазина, адрес магазина, кол-во дней в неделе, в которые работает магазин.
if exists (select * from sysobjects 
                  where id = object_id(N'Procedure4_3')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure Procedure4_3
go
create procedure Procedure4_3 @idgoods int, @countdeals smallint
as
	select s.name_shop,s.address,d.weekdays	
		from Buy b
			 left join Shop s on s.code_shop=b.code_shop
			 join (select sch.code_shop,count(sch.day_week) as weekdays
					from  Schedule sch
					group by sch.code_shop) as d on d.code_shop=s.code_shop
		where b.id_goods=@idgoods
		group by s.name_shop,s.address,d.weekdays
		having count(b.code_shop)>@countdeals
go
execute Procedure4_3 @idgoods=13, @countdeals=2

--4.	Напишите хранимую процедуру, которая выводит ВСЕ товары, суммарное кол-во купленных единиц для каждого товара
-- в указанном магазине и суммарную скидку (в данном случае подразумевается скидка в денежном выражении,
-- т.е. сумма, на которую была уменьшена цена продаваемого товара). Входной параметр процедуры – код магазина,
-- для которого анализировать продажи. Результат запроса должен содержать следующие поля: код товара, 
--суммарное кол-во товара и суммарная скидка на товары (в случае, если в указанном магазине не было продаж данного товара, 
--то товар в данном списке должен присутствовать, а в столбцах кол-ва и скидки должны быть null).
if exists (select * from sysobjects 
                  where id = object_id(N'Procedure4_4')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure Procedure4_4
go
create procedure Procedure4_4 @shop char(5)
as
	select g.id_goods,sum(b.count_buy) as Sum_count,
			sum(b.price*(b.discount/100)) as Sum_discount
		from Goods g
				 left join Buy b on g.id_goods=b.id_goods and 
				 b.code_shop=@shop
		group by g.id_goods,b.code_shop
go
execute Procedure4_4 @shop='2'

--5.	Напишите хранимую процедуру, выводящую Фамилию самого ценного покупателя, т.е.  заплатившего больше всего за покупки в определённый период.
-- Входные параметры процедуры: начало и конец периода. Выходной параметр: фамилия самого ценного покупателя.
-- Также процедура в виде результата запроса должна возвращать перечень покупок данного покупателя
-- (в результате запроса должны присутствовать столбцы: идентификатор товара, наименование товара, код магазина, наименование магазина, кол-во купленного товара, сумма покупки).
-- Покупатели с одинаковой фамилией, но разными инициалами считаются одним «покупателем». 
--Обратите внимание, что в поле «Покупатель» могут быть внесены ФИО покупателей в разных форматах.
if exists (
   select * 
      from sysobjects 
      where id = object_id(N'Procedure4_5')  and objectproperty(id, N'IsProcedure') = 1)
   drop procedure Procedure4_5
go
create procedure Procedure4_5 
	@begin datetime, @end datetime, @family varchar(30) output
as
   select @family = x.Buyer
      from(
         select top 1 Buyers.Buyer as Buyer, sum(Buyers.Cost) as Cost
            from (
               select (case when charindex(' ', b.buyer)=0 then b.buyer
			 else substring(b.buyer,0, charindex(' ', b.buyer))
			 end) as Buyer, 
			 (case when b.discount is null then b.count_buy*b.price
			 else b.count_buy*b.price*((100-b.discount)/100) 
                     end) as Cost
                  from Buy b) as Buyers
         group by Buyers.Buyer
         order by sum(Buyers.Cost) desc) as x;
   select b.buyer, b.id_goods, p.name_goods as p_name, s.code_shop, 
         s.name_shop as s_name, b.count_buy, 
	  (case when b.discount is null then b.count_buy*b.price
	  else b.count_buy*b.price*((100-b.discount)/100) end) as Cost
      from Buy b
         left join Goods p on p.id_goods=b.id_goods
         left join Shop s on s.code_shop=b.code_shop
      where b.buyer like '%' + @family + '%' and b.datetime_buy between @begin and @end
go
declare @family varchar(30)
execute Procedure4_5 '2010-15-01','2014-15-12',@family output
select @family as Best_Buyer
go