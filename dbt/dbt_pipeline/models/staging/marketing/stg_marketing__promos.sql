select
    id as promo_id,
    code as promocode,
    discount_pct,
    start_dt as start_ts,
    end_dt as end_ts,
    {{ add_etl_timestamp() }}
from {{ source('marketing', 'promos') }}
