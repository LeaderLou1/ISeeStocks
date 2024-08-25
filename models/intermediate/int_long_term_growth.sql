-- models/intermediate/int_long_term_growth.sql

with long_term_growth as (
    select
        ticker,
        first_value(close) over (partition by ticker order by date) as first_close,
        last_value(close) over (partition by ticker order by date) as last_close,
        (last_close - first_close) / first_close as growth_rate
    from {{ ref('stg_stock_prices') }}
)

select distinct ticker, growth_rate from long_term_growth
