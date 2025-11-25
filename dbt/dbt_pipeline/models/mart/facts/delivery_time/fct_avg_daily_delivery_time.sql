select
    order_date,
    avg(
        date_diff('second', created_at, delivered_at)
    ) as avg_daily_delivery_time_seconds,
    {{ add_etl_timestamp() }}
from {{ ref('stg_orders__orders') }}
where
    status = 'delivered'
    {% if is_incremental() %}
        and order_date >= date_add('day', -2, current_date)
    {% endif %}
group by order_date
order by order_date
