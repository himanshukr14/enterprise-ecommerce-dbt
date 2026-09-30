select
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    cast(quantity * unit_price as decimal(18,2)) as line_item_amount,
    updated_at
from {{ ref('stg_order_items') }}
