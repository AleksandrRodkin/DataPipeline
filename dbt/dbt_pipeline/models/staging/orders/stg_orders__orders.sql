select
    id as order_id,
    created_at,
    accepted_at,
    delivered_at,
    user_id,
    restaurant_id,
    courier_id,
    status,
    platform as user_platform,
    total_amount,
    payment_method,
    promo_id,
    date as order_date,
    {{ add_etl_timestamp() }}
from {{ source('orders', 'orders') }}
