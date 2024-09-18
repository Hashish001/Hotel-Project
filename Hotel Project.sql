create view hotel AS (
    select * from dbo.[2018]
    union
    select * from dbo.[2019]
    union
    select * from dbo.[2020]
)


SELECT arrival_date_year,hotel,round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue FROM hotel
group by arrival_date_year,hotel

select * from market_segment

-- total bookings and cancellations
select count(*) as total_bookings,
sum(case when is_canceled = 1 then 1 else 0 end) as canceled_bookings
from hotel;


-- cancellation rate by hotel type
select hotel,sum(case when is_canceled = 1 then 1 else 0 end) as cancellation_rate
from hotel
group by hotel;

--busiest months for bookings
select arrival_date_month,count(*) as total_bookings from hotel
group by arrival_date_month
order by total_bookings desc;

--average stay duration by reserved room type
select reserved_room_type,
avg(stays_in_weekend_nights + stays_in_week_nights) as avg_stay_duration
from hotel
group by reserved_room_type;

-- number of bookings by distribution channel
select distribution_channel,count(*) as total_bookings
from hotel
group by distribution_channel;

--total bookings by customer type
select customer_type,count(*) as total_bookings
from hotel
group by customer_type;

--highest average daily rate (adr) by reserved room type
select reserved_room_type,max(adr) as highest_adr
from hotel
group by reserved_room_type;

--number of bookings by country
select country,count(*) as total_bookings
from hotel
group by country
order by total_bookings desc;

--average number of booking changes by reserved room type
select reserved_room_type,
round(avg(booking_changes),3) as avg_booking_changes
from hotel
group by reserved_room_type;

-- number of bookings requiring car parking spaces
select count(*) as bookings_with_parking
from hotel
where required_car_parking_spaces > 0;



--Percentage of Repeat Guests by Hotel
select hotel,
round(sum(case when is_repeated_guest = 1 then 1 else 0 end) * 100.0 / count(*),2) as repeat_guest_percentage
from hotel
group by hotel


--Average Stay Duration by Customer Type and Month
select customer_type,arrival_date_month,
avg(stays_in_weekend_nights + stays_in_week_nights) as avg_stay_duration
from hotel
group by customer_type, arrival_date_month
order by customer_type, arrival_date_month;

--Top 3 Markets with the Highest Average ADR
with market_adr as (
    select market_segment,avg(adr) as average_adr
    from hotel
    group by market_segment
)
select top 3 market_segment,round(average_adr,2)
from market_adr
order by average_adr desc


-- BowerBI query for visualization
select * from hotel h
left join market_segment m_s on m_s.market_segment=h.market_segment
left join meal_cost m_c on m_c.meal=h.meal
