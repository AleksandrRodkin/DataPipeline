select
    id as session_id,
    user_id,
    started_at,
    ended_at,
    actions as action_nubmer,
    platform,
    date as session_date,
    {{ add_etl_timestamp() }}
from {{ source('app', 'sessions') }}
