with source_data as (

    select
        customer_id,
        first_name,
        last_name,
        lower(trim(email)) as email,
        trim(city) as city,
        trim(country) as country,
        cast(signup_date as date) as signup_date,
        cast(updated_at as timestamp) as updated_at
    from {{ source('ecommerce_raw', 'customers') }}

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by customer_id
            order by updated_at desc
        ) as rn

    from source_data

)

select
    customer_id,
    first_name,
    last_name,
    email,
    city,
    country,
    signup_date,
    updated_at

from deduplicated

where rn = 1
