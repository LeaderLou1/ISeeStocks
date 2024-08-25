-- models/intermediate/int_price_momentum.sql

with price_momentum as (
    select
        date,
        ticker,
        close - lag(close, 5) over (partition by ticker order by date) as momentum_5_days,
        close - lag(close, 20) over (partition by ticker order by date) as momentum_20_days
    from {{ ref('stg_stock_prices') }}
)

select * from price_momentum
where momentum_5_days is not null or momentum_20_days is not null