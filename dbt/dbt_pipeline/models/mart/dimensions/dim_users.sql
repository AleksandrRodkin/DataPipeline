with
    users as (select * from {{ ref('stg_app__users') }}),

    orders as (select * from {{ ref('stg_orders__orders') }}),

    user_orders as (

        select
            user_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(order_id) as number_of_orders

        from orders

        group by user_id

    )

select
    users.user_id,
    users.user_name,
    user_orders.first_order_date,
    user_orders.most_recent_order_date,
    coalesce(user_orders.number_of_orders, 0) as number_of_orders,
    {{ add_etl_timestamp() }}

from users

left join user_orders on users.user_id = user_orders.user_id
