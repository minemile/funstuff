use URFU_TASKS;
--1
SELECT * FROM register_buy r
WHERE r.date_time<'20100801 00:00:00'

--2
SELECT p.name, cast(rb.date_time as date), cast(rb.date_time as time), rb.custumer, rb.[count]
FROM register_buy rb JOIN products p ON rb.prod_id=p.id
WHERE rb.shops_code='1' and rb.date_time between '20101201 00:00:00' and '20101231 00:00:00'

--3
SELECT p.id, p.name, AVG(rb.discount), min(rb.price), max(rb.price)
FROM register_buy rb JOIN products p ON rb.prod_id=p.id
group by p.id, p.name
order by p.name

--4
SELECT name, SUM(end_work_hour * 60 + end_work_minute - (start_work_hour * 60 + start_work_minute)) / 60,
SUM(end_work_hour * 60 + end_work_minute - (start_work_hour * 60 + start_work_minute)) % 60
FROM schedule s JOIN shops sh ON s.shops_code=sh.code
group by name
