use URFU_TASKS;
SELECT sum(s.end_work_hour - s.start_work_hour)
FROM schedule s
WHERE s.shops_week between 1 and 2
group by s.shops_code