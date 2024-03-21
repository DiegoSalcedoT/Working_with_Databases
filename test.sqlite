select count(*)
from newspaper
where 
    start_month <= 3
    and
    end_month >= 3;

select *
from newspaper
cross join months;

select *
from newspaper
cross join months
where 
    start_month <= month
    and
    end_month >= month;


SELECT month,
  COUNT(*)
FROM newspaper
CROSS JOIN months
WHERE start_month <= month AND end_month >= month
GROUP BY month;
