use URFU_TASKS;
--1
IF EXISTS ( SELECT * FROM dbo.sysobjects
	WHERE id = object_id(N'p1') and objectproperty(id, N'isProcedure')=1
) 
DROP PROCEDURE p1;
GO

CREATE PROCEDURE p1 @substr VARCHAR(20) AS
SELECT sp.name, rb.buy_id, rb.custumer, pr.name, (rb.[count] * rb.price * (1 - rb.discount/100))
FROM register_buy rb JOIN products pr ON rb.prod_id = pr.id JOIN shops sp ON rb.shops_code=sp.code
WHERE pr.name LIKE '%' + @substr + '%';
go
--EXECUTE p1 '��';

--2
IF EXISTS ( SELECT * FROM dbo.sysobjects
	WHERE id = object_id(N'p2') and objectproperty(id, N'isProcedure')=1
) 
DROP PROCEDURE p2;
GO

CREATE PROCEDURE p2 @s_date SMALLDATETIME, @e_date SMALLDATETIME AS
SELECT sum((rb.[count]*rb.price) * (1 - rb.discount/100)), AVG(rb.price)
FROM register_buy rb 
WHERE rb.date_time BETWEEN @s_date AND @e_date
GROUP BY rb.prod_id;
GO
--EXECUTE p2 '20130101', '20150101';

--3
IF EXISTS ( SELECT * FROM dbo.sysobjects
	WHERE id = object_id(N'p3') and objectproperty(id, N'isProcedure')=1
) 
DROP PROCEDURE p3;
GO

CREATE PROCEDURE p3 @pr_id int, @counter int as 
SELECT sh.name, sh.[address], weeknd
FROM register_buy rb JOIN shops sh ON rb.shops_code=sh.code JOIN (
SELECT sc.shops_code, COUNT(*) as weeknd
from schedule sc
group by sc.shops_code) as w on w.shops_code=sh.code
group by sh.name, sh.[address], weeknd
HAVING COUNT(rb.count) > @counter;
GO 

--execute p3 @pr_id=1, @counter=3;

--4
IF EXISTS ( SELECT * FROM dbo.sysobjects
	WHERE id = object_id(N'p4') and objectproperty(id, N'isProcedure')=1
) 
DROP PROCEDURE p4;
GO

CREATE PROCEDURE p4 @shop_id smallint as
SELECT pr.name, sum(rb.[count]), sum((rb.[count]*price) * (rb.discount/100))
FROM register_buy rb FULL JOIN products pr ON rb.prod_id=pr.id
WHERE rb.shops_code=@shop_id
GROUP BY pr.name;
GO
execute p4 @shop_id=1