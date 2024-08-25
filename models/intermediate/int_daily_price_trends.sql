-- models/intermediate/int_daily_price_trends.sql

with price_trends as (
    select
        date,
        ticker,
        case 
            when close > lag(close) over (partition by ticker order by date) then 'Upward'
            when close < lag(close) over (partition by ticker order by date) then 'Downward'
            else 'Stable'
        end as trend
    from {{ ref('stg_stock_prices') }}
)

select * from price_trends
where trend is not null
