select
    payment_id,
    order_id,
    payment_status,
    payment_amount,
    successful_payment_amount
from {{ ref('fct_payments') }}
where
    (
        payment_status = 'success'
        and abs(successful_payment_amount - payment_amount) > 0.01
    )
    or
    (
        payment_status != 'success'
        and abs(successful_payment_amount) > 0.01
    )