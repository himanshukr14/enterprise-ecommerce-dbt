{% macro create_raw_schema() %}

    {% do run_query("create schema if not exists ecommerce_dev.raw") %}

{% endmacro %}