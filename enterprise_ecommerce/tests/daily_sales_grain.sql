select
    order_date,
    currency,
    count(*) as row_count
from {{ ref('daily_sales') }}
group by
    order_date,
    currency
having count(*) > 1