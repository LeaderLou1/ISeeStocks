with stock_data as (
    select
        s.date,
        s.ticker,
        s.close,
        sm.sector
    from {{ ref('stg_stock_prices') }} s
    left join {{ source('raw_data', 'sector_mapping') }} sm
    on s.ticker = sm.ticker
)

select 
    sector,
    date,
    avg(close) as avg_close_price
from stock_data
group by sector, date
order by sector, date
