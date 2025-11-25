{% set day_lag = 2 %}

with
    cte as (
        select *
        from {{ ref('fct_dau') }}
        {% if is_incremental() %}
            where session_date >= date_add('day', -30 - {{ day_lag }}, current_date)
        {% endif %}
    )

select
    session_date,
    sum(dau) over (
        order by session_date range between interval '29' day preceding and current row
    ) as mau,
    {{ add_etl_timestamp() }}
from cte
{% if is_incremental() %}
    where session_date >= date_add('day', -{{ day_lag }}, current_date)
{% endif %}
order by session_date
