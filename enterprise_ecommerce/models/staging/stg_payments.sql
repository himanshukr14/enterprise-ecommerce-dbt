with source as (

    select *
    from {{ source('ecommerce_raw', 'payments') }}

),

renamed as (

    select
        cast(payment_id as bigint) as payment_id,
        cast(order_id as bigint) as order_id,
        cast(payment_date as timestamp) as payment_date,
        upper(trim(payment_method)) as payment_method,
        lower(trim(payment_status)) as payment_status,
        cast(amount as decimal(18, 2)) as amount,
        upper(trim(currency)) as currency,
        cast(updated_at as timestamp) as updated_at,
        _loaded_at

    from source

)

select *
from renamed
