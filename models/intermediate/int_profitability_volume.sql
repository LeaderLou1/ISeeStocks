-- models/intermediate/int_profitability_volume.sql

with profitability_volume as (
    select
        ticker,
        avg(close - open) as avg_profit,
        avg(volume) as avg_volume
    from {{ ref('stg_stock_prices') }}
    group by ticker
)

select * from profitability_volume