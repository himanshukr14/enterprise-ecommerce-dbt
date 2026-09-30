with customer_snapshot as (

    select *
    from {{ ref('snap_customers') }}

),

current_customers as (

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
    from customer_snapshot
    where dbt_valid_to is null

)

select *
from current_customers
