with daily_returns as (
    select 
        date,
        ticker,
        (close - lag(close) over (partition by ticker order by date)) / lag(close) over (partition by ticker order by date) as return_value,
        'daily' as return_type
    from {{ ref('stg_stock_prices') }}
),

monthly_returns as (
    select 
        last_day(date) as date,  -- Use last day of the month for the date
        ticker,
        (close - lag(close) over (partition by ticker order by last_day(date))) / lag(close) over (partition by ticker order by last_day(date)) as return_value,
        'monthly' as return_type
    from (
        select 
            ticker,
            date,
            close,
            row_number() over (partition by ticker, date_trunc('month', date) order by date desc) as rn
        from {{ ref('stg_stock_prices') }}
    ) where rn = 1
)

select date, ticker, return_value, return_type
from daily_returns
union all
select date, ticker, return_value, return_type
from monthly_returns
order by ticker, date
