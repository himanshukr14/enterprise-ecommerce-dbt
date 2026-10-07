-- Slim CI validation change
with order_daily as (

    select
        order_date,
        currency,

        count(*) as total_orders,

        sum(
            case
                when status = 'completed' then 1
                else 0
            end
        ) as completed_orders,

        sum(
            case
                when status = 'cancelled' then 1
                else 0
            end
        ) as cancelled_orders,

        sum(total_items) as total_items,
        sum(total_quantity) as total_quantity,
        sum(order_total) as gross_order_value,
        sum(calculated_order_total) as calculated_order_value

    from {{ ref('fct_orders') }}

    group by
        order_date,
        currency

),

payment_daily as (

    select
        cast(payment_date as date) as payment_date,
        payment_currency as currency,

        count(*) as payment_attempts,

        sum(
            case
                when payment_status = 'success' then 1
                else 0
            end
        ) as successful_payments,

        sum(
            case
                when payment_status = 'failed' then 1
                else 0
            end
        ) as failed_payments,

        sum(
            case
                when payment_status = 'pending' then 1
                else 0
            end
        ) as pending_payments,

        sum(successful_payment_amount) as successful_payment_value

    from {{ ref('fct_payments') }}

    group by
        cast(payment_date as date),
        payment_currency

)

select
    o.order_date,
    o.currency,

    o.total_orders,
    o.completed_orders,
    o.cancelled_orders,

    o.total_items,
    o.total_quantity,

    o.gross_order_value,
    o.calculated_order_value,

    coalesce(p.payment_attempts, 0) as payment_attempts,
    coalesce(p.successful_payments, 0) as successful_payments,
    coalesce(p.failed_payments, 0) as failed_payments,
    coalesce(p.pending_payments, 0) as pending_payments,
    coalesce(p.successful_payment_value, 0) as successful_payment_value

from order_daily o

left join payment_daily p
    on o.order_date = p.payment_date
    and o.currency = p.currency