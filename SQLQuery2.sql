use URFU_TASKS;
IF EXISTS ( SELECT * FROM dbo.sysobjects
	WHERE id = object_id(N'p51') and objectproperty(id, N'isProcedure')=1
) 
DROP PROCEDURE p51;
GO
CREATE PROCEDURE p51 @code varchar(15), @year int, @month int as
CREATE TABLE #month_per_day(day_month int null)
	declare @day int;
	declare @date datetime;
	set @day=1;
	set @date = convert (datetime, cast(@year as varchar) + right('0'+@month, 2) + '01');
	select @date
	while @month = month(@date)
		begin
			insert into #month_per_day values (@day)
			set @day=@day+1
			set @date = dateadd(day, 1, @date)
		end
SELECT * FROM #month_per_day

SELECT t2.month_day, sum(case when t1.month_day <= t2.month_day then t1.[sum] else 0 end)
from (
	select day(rb.date_time) as month_day, sum((rb.[count] * rb.price) * (1-rb.discount/100)) as [sum]
	FROM products p
	JOIN register_buy rb ON p.id=rb.prod_id
	WHERE p.id=@code and year(rb.date_time) = @year AND month(rb.date_time)=@month
	GROUP BY rb.date_time) as t1
	cross join (
	select m.day_month as month_day
	from #month_per_day as m) as t2
	group by t2.month_day
GO
execute p51 '01',2010,12
--2

--3
select p.code, p.name, Av.avårage, rb.price
from products p
  inner join register_buy rb on rb.prod_id = p.id
  inner join (select rb.prod_id, avg(rb.price) as avårage
        from register_buy rb
        group by rb.prod_id
       ) as Av 
	on rb.prod_id = Av.prod_id
where rb.price < Av.avårage