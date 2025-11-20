select
    id as restaurant_id,
    name,
    city,
    cuisine_type,
    rating,
    work_start_time as opened_at,
    work_end_time as closed_at,
    is_24h,
    modified_at as last_change_dt
from {{ source('orders', 'restaurants') }}
