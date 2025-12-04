select
    id as user_id,
    name as user_name,
    city,
    platform,
    gender,
    birth_date,
    registration_dt,
    date as registration_date,
    {{ add_etl_timestamp() }}
from {{ source('app', 'users') }}
