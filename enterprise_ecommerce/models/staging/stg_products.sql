select
    product_id,
    trim(product_name) as product_name,
    trim(category) as category,
    trim(subcategory) as subcategory,
    trim(brand) as brand,
    cast(unit_cost as decimal(18,2)) as unit_cost,
    cast(list_price as decimal(18,2)) as list_price,
    upper(trim(currency)) as currency,
    cast(updated_at as timestamp) as updated_at
from {{ source('ecommerce_raw', 'products') }}