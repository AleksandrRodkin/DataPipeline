CREATE SCHEMA IF NOT EXISTS app;
CREATE SCHEMA IF NOT EXISTS orders;
CREATE SCHEMA IF NOT EXISTS payments;
CREATE SCHEMA IF NOT EXISTS marketing;


-- ------------------------------------------------
-- SCHEMA: app
-- ------------------------------------------------
CREATE TABLE IF NOT EXISTS app.users (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    platform VARCHAR(10) CHECK (platform IN ('ios', 'android', 'web')),
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    birth_date DATE,
    registration_dt TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS app.sessions (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL REFERENCES app.users(id),
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP,
    actions INT,
    platform VARCHAR(10)
    -- source VARCHAR(10) CHECK (source IN ('organic', 'ad', 'referral'))
);

-- ------------------------------------------------
-- SCHEMA: orders
-- ------------------------------------------------
CREATE TABLE IF NOT EXISTS orders.restaurants (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    cuisine_type VARCHAR(50),
    rating FLOAT CHECK (rating >= 0 AND rating <= 5),
    work_start_time TIME,
    work_end_time TIME,
    is_24h BOOLEAN DEFAULT FALSE,
    modified_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders.couriers (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    transport VARCHAR(10) CHECK (transport IN ('bike', 'car', 'walk')),
    rating FLOAT CHECK (rating >= 0 AND rating <= 5),
    modified_at TIMESTAMP
);

-- ------------------------------------------------
-- SCHEMA: marketing
-- ------------------------------------------------
CREATE TABLE IF NOT EXISTS marketing.promos (
    id VARCHAR(50) PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    discount_pct INT CHECK (discount_pct >= 0 AND discount_pct <= 100),
    start_dt TIMESTAMP NOT NULL,
    end_dt TIMESTAMP NOT NULL
    -- campaign_name VARCHAR(255)
);

-- CREATE TABLE IF NOT EXISTS marketing.user_promos (
-- user_id INT NOT NULL REFERENCES app.users(id),
-- promo_code VARCHAR(50) NOT NULL REFERENCES marketing.promos(promo_code),
-- used_dt TIMESTAMP,
-- PRIMARY KEY (user_id, promo_code)
-- );
-- ------------------------------------------------
-- SCHEMA: orders (cont)
-- ------------------------------------------------
CREATE TABLE IF NOT EXISTS orders.orders (
    id VARCHAR(50) PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    accepted_at TIMESTAMP,
    delivered_at TIMESTAMP,
    user_id VARCHAR(50) NOT NULL REFERENCES app.users(id),
    restaurant_id VARCHAR(50) NOT NULL REFERENCES orders.restaurants(id),
    courier_id VARCHAR(50) REFERENCES orders.couriers(id),
    status VARCHAR(10) CHECK (status IN ('delivered', 'cancelled', 'failed')),
    platform VARCHAR(10) CHECK (platform IN ('ios', 'android', 'web')),
    total_amount DECIMAL(10,2),
    -- payment_id INT REFERENCES payments.payments(payment_id)
    payment_method VARCHAR(50),
    promo_id VARCHAR(50) REFERENCES marketing.promos(id)
);

-- CREATE TABLE IF NOT EXISTS orders.order_items (
-- order_item_id SERIAL PRIMARY KEY,
-- order_id INT NOT NULL REFERENCES orders.orders(order_id),
-- product_name VARCHAR(255) NOT NULL,
-- category VARCHAR(100),
-- price DECIMAL(10,2) NOT NULL
-- );
-- ------------------------------------------------
-- SCHEMA: payments
-- ------------------------------------------------
-- CREATE TABLE IF NOT EXISTS payments.payments (
-- payment_id SERIAL PRIMARY KEY,
-- user_id INT NOT NULL REFERENCES app.users(id),
-- order_id INT REFERENCES orders.orders(order_id),
-- payment_dt TIMESTAMP NOT NULL,
-- payment_method VARCHAR(20) CHECK (payment_method IN ('card', 'apple_pay',
-- 'google_pay')),
-- status VARCHAR(10) CHECK (status IN ('success', 'failed')),
-- amount DECIMAL(10,2) NOT NULL
-- );
