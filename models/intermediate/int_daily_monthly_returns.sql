with daily_returns as (
    select 
        date,
        ticker,
        (close - lag(close) over (partition by ticker order by date)) / lag(close) over (partition by ticker order by date) as daily_return
    from {{ ref('stg_stock_prices') }}
),
monthly_returns as (
    select 
        date_trunc('month', date) as month,
        ticker,
        (sum(close) - lag(sum(close)) over (partition by ticker order by date_trunc('month', date))) / lag(sum(close)) over (partition by ticker order by date_trunc('month', date)) as monthly_return
    from {{ ref('stg_stock_prices') }}
    group by month, ticker
)
select * from daily_returns
union all
select * from monthly_returns
