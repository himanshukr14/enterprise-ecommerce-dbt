select
    order_item_id,
    order_id,
    product_id,
    cast(quantity as integer) as quantity,
    cast(unit_price as decimal(18,2)) as unit_price,
    cast(updated_at as timestamp) as updated_at
from {{ source('ecommerce_raw', 'order_items') }}
