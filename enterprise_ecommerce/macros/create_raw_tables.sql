{% macro create_raw_tables() %}

    {% do run_query(
        "create or replace table ecommerce_dev.raw.customers as
         select *,
                current_timestamp() as _loaded_at
         from ecommerce_dev.dbt_dev.customers"
    ) %}

    {% do run_query(
        "create or replace table ecommerce_dev.raw.orders as
         select *,
                current_timestamp() as _loaded_at
         from ecommerce_dev.dbt_dev.orders"
    ) %}

    {% do run_query(
        "create or replace table ecommerce_dev.raw.order_items as
         select *,
                current_timestamp() as _loaded_at
         from ecommerce_dev.dbt_dev.order_items"
    ) %}

        {% do run_query(
        "create or replace table ecommerce_dev.raw.products as
         select *,
                current_timestamp() as _loaded_at
         from ecommerce_dev.dbt_dev.products"
    ) %}

{% endmacro %}