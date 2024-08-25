-- models/staging/stg_stock_prices.sql

with cleaned_data as (
    select
        date,
        ticker,
        cast(open as double) as open,
        cast(high as double) as high,
        cast(low as double) as low,
        cast(close as double) as close,
        cast(adj_close as double) as adj_close,
        cast(volume as bigint) as volume
    from {{ source('raw_data', 'stockwatch') }}
    where date is not null
      and ticker is not null
      and open is not null
      and high is not null
      and low is not null
      and close is not null
      and adj_close is not null
      and volume is not null
)

select * from cleaned_data
