select
    id as session_id, user_id, started_at, ended_at, actions as action_nubmer, platform
from {{ source('source_app', 'sessions') }}
