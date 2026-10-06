with payments as (

    select *
    from {{ ref('stg_payments') }}

),

orders as (

    select
        order_id,
        customer_id,
        status as order_status,
        order_date,
        order_total,
        currency as order_currency
    from {{ ref('fct_orders') }}

),

payment_fact as (

    select
        p.payment_id,
        p.order_id,
        o.customer_id,
        p.payment_date,
        p.payment_method,
        p.payment_status,
        p.amount as payment_amount,
        p.currency as payment_currency,
        o.order_status,
        o.order_date,
        o.order_total,
        o.order_currency,
        case
            when p.payment_status = 'success' then p.amount
            else cast(0 as decimal(18, 2))
        end as successful_payment_amount,
        p.updated_at
    from payments p
    left join orders o
        on p.order_id = o.order_id

)

select *
from payment_fact
