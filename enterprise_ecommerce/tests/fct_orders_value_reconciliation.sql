select
    order_id,
    order_total,
    calculated_order_total
from {{ ref('fct_orders') }}
where abs(order_total - calculated_order_total) > 0.01
