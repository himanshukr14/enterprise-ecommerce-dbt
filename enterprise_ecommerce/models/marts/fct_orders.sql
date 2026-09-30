-- depends_on: {{ ref('stg_order_items') }}
{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

with changed_order_ids as (

    {% if is_incremental() %}

    select
        order_id
    from {{ ref('stg_orders') }}
    where updated_at >= (
        select coalesce(
            max(updated_at),
            cast('1900-01-01' as timestamp)
        )
        from {{ this }}
    )

    union

    select
        order_id
    from {{ ref('stg_order_items') }}
    where updated_at >= (
        select coalesce(
            max(updated_at),
            cast('1900-01-01' as timestamp)
        )
        from {{ this }}
    )

    {% else %}

    select
        order_id
    from {{ ref('stg_orders') }}

    {% endif %}

),

orders as (

    select *
    from {{ ref('stg_orders') }}
    where order_id in (
        select order_id
        from changed_order_ids
    )

),

customers as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        city,
        country
    from {{ ref('dim_customers') }}

),

order_metrics as (

    select *
    from {{ ref('int_orders_enriched') }}

),

orders_with_customer_key as (

    select
        o.*,

        case
            when c.customer_id is null then -1
            else o.customer_id
        end as warehouse_customer_id

    from orders o

    left join customers c
        on o.customer_id = c.customer_id

)

select
    o.order_id,
    o.warehouse_customer_id as customer_id,

    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.country,

    o.order_date,
    o.status,
    o.currency,

    o.order_total,
    om.calculated_order_total,
    om.total_items,

    o.updated_at

from orders_with_customer_key o

left join customers c
    on o.warehouse_customer_id = c.customer_id

left join order_metrics om
    on o.order_id = om.order_id
