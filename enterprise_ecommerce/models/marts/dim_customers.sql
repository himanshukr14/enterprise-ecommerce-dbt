with customers as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        city,
        country,
        signup_date,
        updated_at,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('int_customers_current') }}

),

dimension as (

    select *
    from customers

    union all

    select
        -1 as customer_id,
        'Unknown' as first_name,
        'Customer' as last_name,
        cast(null as string) as email,
        'Unknown' as city,
        'Unknown' as country,
        cast(null as date) as signup_date,
        cast(null as timestamp) as updated_at,
        cast(null as timestamp) as dbt_valid_from,
        cast(null as timestamp) as dbt_valid_to

)

select *
from dimension
