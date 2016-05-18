use URFU_TASKS;
SELECT * FROM register_buy
WHERE date_time<'20100801 00:00:00'

SELECT name, date_time, custumer, [count]
FROM register_buy r JOIN products p ON r.prod_id=p.id
WHERE shops_code='1' AND date_time between convert(datetime, '2010-12-01',120) AND CONVERT(datetime, '2010-12-31',120)

SELECT p.id,p.name,avg(r.discount),min(r.price),max(r.price)from register_buy r
JOIN products p ON r.prod_id=p.id
GROUP BY p.id, p.name
ORDER BY p.name

SELECT
          z.name
        , (SUM(CASE WHEN(c.end_work_hour>=c.start_work_hour
                              ) THEN ((c.end_work_hour-start_work_hour)*60+ (c.end_work_minute-c.start_work_minute)) ELSE((24-c.start_work_hour+c.end_work_hour)*60+(c.end_work_minute-c.start_work_minute)) END))/60 as hours
        , (SUM(CASE WHEN(c.end_work_minute>=c.start_work_minute
                              ) THEN ((c.end_work_hour-start_work_hour)*60+ (c.end_work_minute-c.start_work_minute)) ELSE((c.end_work_hour-c.start_work_hour-1)*60+(c.end_work_minute-c.start_work_minute)) END))%60 as minutes
FROM
          shops z
          JOIN
                    schedule c
          ON
                    c.shops_code=z.code
GROUP BY
          z.name
