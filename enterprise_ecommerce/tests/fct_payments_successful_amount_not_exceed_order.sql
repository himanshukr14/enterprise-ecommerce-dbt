select
    order_id,
    max(order_total) as order_total,
    sum(successful_payment_amount) as successful_payment_value
from {{ ref('fct_payments') }}
group by order_id
having sum(successful_payment_amount) > max(order_total) + 0.01