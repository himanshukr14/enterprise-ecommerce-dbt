with mismatches as (

    select
        order_id,
        order_total,
        calculated_order_total,
        abs(order_total - calculated_order_total) as difference
    from {{ ref('fct_orders') }}
    where abs(order_total - calculated_order_total) > 0.01

)

select *
from mismatches
