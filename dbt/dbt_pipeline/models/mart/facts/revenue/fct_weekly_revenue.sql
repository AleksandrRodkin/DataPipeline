{% set day_lag = 2 %}

with
    cte as (
        select *
        from {{ ref('fct_daily_revenue') }}
        {% if is_incremental() %}
            where order_date >= date_add('day', -7 - {{ day_lag }}, current_date)
        {% endif %}
    )

select
    order_date,
    sum(daily_revenue) over (
        order by order_date range between interval '6' day preceding and current row
    ) as weekly_revenue,
    {{ add_etl_timestamp() }}
from cte
{% if is_incremental() %}
    where order_date >= date_add('day', -{{ day_lag }}, current_date)
{% endif %}
order by order_date
