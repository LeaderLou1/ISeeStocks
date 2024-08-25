-- models/intermediate/int_most_volatile_stocks.sql

with volatility_rank as (
    select
        ticker,
        avg((high - low) / open) as avg_volatility
    from {{ ref('stg_stock_prices') }}
    group by ticker
)

select * from volatility_rank
order by avg_volatility desc
limit 5
