with orders as (

    select
        order_id,
        customer_id,
        order_date,
        status,
        currency,
        order_total,
        updated_at
    from {{ ref('stg_orders') }}

),

customers as (

    select
        customer_id
    from {{ ref('stg_customers') }}

),

invalid_orders as (

    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status,
        o.currency,
        o.order_total,
        o.updated_at
    from orders o
    left join customers c
        on o.customer_id = c.customer_id
    where c.customer_id is null

)

select *
from invalid_orders