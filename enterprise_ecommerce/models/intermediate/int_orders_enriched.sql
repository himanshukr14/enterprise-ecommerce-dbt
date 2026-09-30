select
    order_id,
    sum(line_item_amount) as calculated_order_total,
    count(*) as total_items,
    max(updated_at) as order_items_updated_at
from {{ ref('int_order_items_enriched') }}
group by order_id
