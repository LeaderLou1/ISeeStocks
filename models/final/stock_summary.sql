-- models/final/stock_summary.sql

with summary as (
    select
        s.ticker,
        s.date,
        sm.sector,
        dr.return_value as daily_return,
        mr.return_value as monthly_return,
        pv.price_volatility,
        ltg.growth_rate as long_term_growth,
        mv.ma_30 as moving_average_30,
        mv.ma_90 as moving_average_90,
        pm.momentum_5_days,
        pm.momentum_20_days,
        vp.volume_price_corr
    from {{ ref('stg_stock_prices') }} s
    left join {{ ref('int_daily_monthly_returns') }} dr on s.ticker = dr.ticker and s.date = dr.date and dr.return_type = 'daily'
    left join {{ ref('int_daily_monthly_returns') }} mr on s.ticker = mr.ticker and s.date = mr.date and mr.return_type = 'monthly'
    left join {{ ref('int_price_volatility') }} pv on s.ticker = pv.ticker and s.date = pv.date
    left join {{ ref('int_long_term_growth') }} ltg on s.ticker = ltg.ticker
    left join {{ ref('int_moving_averages') }} mv on s.ticker = mv.ticker and s.date = mv.date
    left join {{ ref('int_price_momentum') }} pm on s.ticker = pm.ticker and s.date = pm.date
    left join {{ ref('int_volume_price_correlation') }} vp on s.ticker = vp.ticker
    left join {{ source('raw_data', 'sector_mapping') }} sm on s.ticker = sm.ticker
)

select * from summary
