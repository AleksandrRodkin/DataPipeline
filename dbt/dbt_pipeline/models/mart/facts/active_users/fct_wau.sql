{% set day_lag = 2 %}

with
    cte as (
        select *
        from {{ ref('fct_dau') }}
        {% if is_incremental() %}
            where session_date >= date_add('day', -7 - {{ day_lag }}, current_date)
        {% endif %}
    )

select
    session_date,
    sum(dau) over (
        order by session_date range between interval '6' day preceding and current row
    ) as wau,
    {{ add_etl_timestamp() }}
from cte
{% if is_incremental() %}
    where session_date >= date_add('day', -{{ day_lag }}, current_date)
{% endif %}
order by session_date
