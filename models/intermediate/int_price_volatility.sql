-- models/intermediate/int_price_volatility.sql

with price_volatility as (
    select
        date,
        ticker,
        (high - low) / open as price_volatility
    from {{ ref('stg_stock_prices') }}
)

select * from price_volatility
where price_volatility is not null
