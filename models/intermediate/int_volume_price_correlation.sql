-- models/intermediate/int_volume_price_correlation.sql

with volume_price_correlation as (
    select
        ticker,
        corr(volume, close) as volume_price_corr
    from {{ ref('stg_stock_prices') }}
    group by ticker
)

select * from volume_price_correlation
