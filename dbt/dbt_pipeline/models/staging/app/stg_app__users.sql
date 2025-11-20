select
    id as user_id,
    name as user_name,
    city,
    platform,
    gender,
    birth_date,
    registration_dt
from {{ source('app', 'users') }}
