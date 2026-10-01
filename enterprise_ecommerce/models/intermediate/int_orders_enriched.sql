with order_items as (

    select
        oi.order_id,
        oi.product_id,
        oi.line_item_amount,
        oi.quantity,
        oi.updated_at,
        p.category
    from {{ ref('int_order_items_enriched') }} oi
    left join {{ ref('dim_products') }} p
        on oi.product_id = p.product_id

),

order_metrics as (

    select
        order_id,
        sum(line_item_amount) as calculated_order_total,
        count(*) as total_items,
        sum(quantity) as total_quantity,
        count(distinct product_id) as distinct_products,
        concat_ws(', ', sort_array(collect_set(category))) as product_categories,
        max(updated_at) as order_items_updated_at
    from order_items
    group by order_id

)

select *
from order_metrics