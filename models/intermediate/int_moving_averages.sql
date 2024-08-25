-- models/intermediate/int_moving_averages.sql

with moving_averages as (
    select
        date,
        ticker,
        avg(close) over (partition by ticker order by date rows between 29 preceding and current row) as ma_30,
        avg(close) over (partition by ticker order by date rows between 89 preceding and current row) as ma_90
    from {{ ref('stg_stock_prices') }}
)

select * from moving_averages
