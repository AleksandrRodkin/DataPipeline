select order_date, count(distinct order_id) as daily_orders, {{ add_etl_timestamp() }}
from {{ ref('stg_orders__orders') }}
where
    status = 'delivered'
    {% if is_incremental() %}
        and order_date >= date_add('day', -2, current_date)
    {% endif %}
group by order_date
order by order_date
