select
    order_id
from {{ ref('int_invalid_order_customers') }}
group by order_id
having count(*) > 1