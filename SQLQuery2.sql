use URFU_TASKS;
IF EXISTS ( SELECT * FROM dbo.sysobjects
	WHERE id = object_id(N'p51') and objectproperty(id, N'isProcedure')=1
) 
DROP PROCEDURE p51;
GO

CREATE PROCEDURE p51 @prod_code int, @year int, @month int AS
CREATE TABLE #days_per_month (
  m_day DATE
)

DECLARE
@s_date DATE;
set @s_date = DATEFROMPARTS(@year, @month, 1)
while @month = month(@s_date)
	BEGIN
	  INSERT INTO #days_per_month VALUES (@s_date)
	  set @s_date = DATEADD(day, 1, @s_date)
	END

SELECT m_day, summa
FROM #days_per_month dm LEFT JOIN
(
	SELECT date_time, sum(rb.[count] * rb.price * (1 - rb.discount/100)) as summa
	FROM register_buy rb
	WHERE rb.prod_id=@prod_code and year(rb.date_time)=@year and month(rb.date_time)=@month
	GROUP BY date_time
) as prod_sum
ON dm.m_day = prod_sum.date_time
GO

execute p51 7, 2010, 01;