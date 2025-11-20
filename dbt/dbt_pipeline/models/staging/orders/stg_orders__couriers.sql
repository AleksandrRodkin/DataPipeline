select
    id as courier_id,
    name as courier_name,
    city,
    transport,
    rating,
    modified_at as last_change_ts
from {{ source('orders', 'couriers') }}
