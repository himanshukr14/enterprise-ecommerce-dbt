select
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    unit_cost,
    list_price,
    currency,
    cast(list_price - unit_cost as decimal(18,2)) as profit_margin,
    cast(
        case
            when list_price = 0 then 0
            else ((list_price - unit_cost) / list_price) * 100
        end
        as decimal(5,2)
    ) as profit_margin_pct,
    updated_at
from {{ ref('stg_products') }}