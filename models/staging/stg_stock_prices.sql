-- models/staging/stg_stock_prices.sql

with cleaned_data as (
    select
        s.date,
        s.ticker,  -- Explicitly reference the ticker from the stockwatch table
        cast(s.open as double) as open,
        cast(s.high as double) as high,
        cast(s.low as double) as low,
        cast(s.close as double) as close,
        cast(s.adj_close as double) as adj_close,
        cast(s.volume as bigint) as volume,
        coalesce(sm.sector, 'Unknown') as sector  -- Explicitly reference the sector from the sector_mapping table
    from {{ source('raw_data', 'stockwatch') }} s
    left join {{ source('raw_data', 'sector_mapping') }} sm
    on s.ticker = sm.ticker
    where s.date is not null
      and s.ticker is not null
      and s.open is not null
      and s.high is not null
      and s.low is not null
      and s.close is not null
      and s.adj_close is not null
      and s.volume is not null
)

select * from cleaned_data

