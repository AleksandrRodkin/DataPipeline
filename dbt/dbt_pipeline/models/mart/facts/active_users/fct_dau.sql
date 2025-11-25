select session_date, count(distinct user_id) as dau, {{ add_etl_timestamp() }}
from {{ ref('stg_app__sessions') }}
{% if is_incremental() %}
    where session_date >= date_add('day', -2, current_date)
{% endif %}
group by session_date
order by session_date
