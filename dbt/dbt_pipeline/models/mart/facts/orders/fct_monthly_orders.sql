{% set day_lag = 2 %}

with
    cte as (
        select *
        from {{ ref('fct_daily_orders') }}
        {% if is_incremental() %}
            where order_date >= date_add('day', -30 - {{ day_lag }}, current_date)
        {% endif %}
    )

select
    order_date,
    sum(daily_orders) over (
        order by order_date range between interval '29' day preceding and current row
    ) as monthly_orders,
    {{ add_etl_timestamp() }}
from cte
{% if is_incremental() %}
    where order_date >= date_add('day', -{{ day_lag }}, current_date)
{% endif %}
order by order_date
