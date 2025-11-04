COPY app.users (id, name, city, platform, gender, birth_date, registration_dt)
FROM '/data/users.csv'
DELIMITER ','
CSV HEADER;

COPY app.sessions (id, user_id, started_at, ended_at, actions, platform)
FROM '/data/sessions.csv'
DELIMITER ','
CSV HEADER;

COPY orders.restaurants (id, name, city, cuisine_type, rating, work_start_time, work_end_time, is_24h)
FROM '/data/restaurants.csv'
DELIMITER ','
CSV HEADER;

COPY orders.couriers (id, name, city, transport, rating)
FROM '/data/couriers.csv'
DELIMITER ','
CSV HEADER;

COPY marketing.promos (id, code, discount_pct, start_dt, end_dt)
FROM '/data/promos.csv'
DELIMITER ','
CSV HEADER;

COPY orders.orders (id, created_at, accepted_at, delivered_at, user_id, restaurant_id, courier_id, status, platform, total_amount, payment_method, promo_id)
FROM '/data/orders.csv'
DELIMITER ','
CSV HEADER;
