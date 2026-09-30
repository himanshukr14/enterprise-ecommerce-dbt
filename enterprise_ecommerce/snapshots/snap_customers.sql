{% snapshot snap_customers %}

{{
    config(
        target_schema='dbt_dev',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    customer_id,
    first_name,
    last_name,
    email,
    city,
    country,
    signup_date,
    updated_at
from {{ ref('customers') }}

{% endsnapshot %}
