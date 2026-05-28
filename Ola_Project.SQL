use ola_project

select * from Ola_rides

-- we will check if is there any duplicate data exist in our database.

select booking_id, count(*) as total_count
from Ola_rides
group by booking_id
having count(*) >1

--The dataset will be cleaned by checking for the presence of missing (NULL) values 
--and determining appropriate methods to handle them.

select * from Ola_rides
where Time is null or
Booking_ID is null or
Booking_Status is null or
Customer_ID is null or
Vehicle_Type is null or
Pickup_Location is null or
Drop_Location is null or
V_TAT is null or
C_TAT is null or
Canceled_Rides_by_Customer  is  null  or
Canceled_Rides_by_Driver is null or
Incomplete_Rides is null or
Incomplete_Rides_Reason is null or
Booking_Value is null or
Payment_Method is null or
Ride_Distance is null or
Driver_Ratings is null or
Customer_Rating is null 

--We will update some column Values where column values contain null.

select * from Ola_rides
where booking_status <>'success'

update Ola_rides set V_TAT= 0
where V_TAT is null

update Ola_rides set C_TAT= 0
where C_TAT is null

update Ola_rides set Canceled_Rides_by_customer = '-'
where Canceled_Rides_by_customer = 'null'


update Ola_rides set Incomplete_Rides_Reason = 'Booking_cancelled'
where Incomplete_Rides_Reason  = 'null'


update Ola_rides set Payment_Method = '-'
where Payment_Method  = 'null'

update Ola_rides set customer_Rating = 0
where Customer_Rating  is null

update Ola_rides set driver_Ratings = 0
where driver_Ratings  is null

update Ola_rides set customer_rating =
format(customer_rating,'N0')

update Ola_rides set Driver_ratings =
format(Driver_ratings,'N0')

select * from Ola_rides

--1. What is the total number of completed rides?

select * from Ola_rides

select count(*) as total_Rides_done
from Ola_rides
where booking_status ='Success'

--2. What is the total revenue from completed rides?

select * from Ola_rides

select sum(booking_value) as total_revenue
from Ola_rides
where booking_status ='Success'


---------------------------------------------------------------------------------------------------


--3. What is the ride completion rate?


select * from Ola_rides

select format(count(
case when booking_status ='success' then 1
end)* 100.0/ count(*),'N2') + ' %' as completion_rate_percentage 
from Ola_rides


--------------------------------------------------------------------------------------------------

--4. At what time are most rides successfully completed?

select * from BOla_rides

select case
when datepart(hour,time) between 0 and 4 then 'Night'
when datepart(hour,time) between 5 and 11 then 'Morning'
when datepart(hour,time) between 12 and 17 then 'Afternoon'
when datepart(hour,time) between 18 and 23 then 'Evening'
end as Timming,
count(*) as total_bookings
from Ola_rides
where booking_status ='Success'
group by case
when datepart(hour,time) between 0 and 4 then 'Night'
when datepart(hour,time) between 5 and 11 then 'Morning'
when datepart(hour,time) between 12 and 17 then 'Afternoon'
when datepart(hour,time) between 18 and 23 then 'Evening'
end
order by total_bookings desc


---------------------------------------------------------------------------------------------------

--5. Which day has the highest number of completed rides?

select * from Ola_rides

select top 1 datename(weekday,date) as Day_name,
count(*) as Completed_rides
from Ola_rides
where booking_status ='Success'
group by datename(weekday,date)
order by Completed_rides desc

---------------------------------------------------------------------------------------------------

--6. Which vehicle type generates the highest revenue from completed rides?

select * from Ola_rides

select vehicle_type,
sum(booking_value)  as revenue
from Ola_rides
where booking_status ='Success'
group by vehicle_type
order by revenue desc

---------------------------------------------------------------------------------------------------

--7. Which vehicle type has the highest completion rate?

select * from Ola_rides

select top 1 vehicle_type,
format(count
(case when booking_status ='success' then 1
end)*100.0/count(*),'N2')+ ' %' as completion_rate
from Ola_rides
group by vehicle_type
order by completion_rate desc


---------------------------------------------------------------------------------------------------

--8. What is the average distance of completed rides?

select * from Ola_rides

select convert(nvarchar(20),avg(ride_distance))+' ' + 'km' as avg_distance
from Ola_rides
where booking_status ='Success'


---------------------------------------------------------------------------------------------------

--9. Which payment method is most used in completed rides?

select * from Ola_rides

select top 1 payment_method,
count(*) as total_rides
from Ola_rides
where booking_status ='Success'
group by payment_method
order by total_rides desc

---------------------------------------------------------------------------------------------------

--10. How do completed rides compare with cancelled rides by vehicle type?

select * from Ola_rides

select vehicle_type,
count(
case when 
booking_status <> 'success' then 1
end ) as cancelled_rides,
count(
case when
booking_status ='success' then 1 
end ) as completed_rides
from Ola_rides
group by vehicle_type
order by vehicle_type

---------------------------------------------------------------------------------------------------

--11. top 5 locations have the highest ride demand?	

select * from Ola_rides

select top 5 pickup_location,
count(*) as ride_demand_no
from Ola_rides
group by pickup_location
order by ride_demand_No desc


---------------------------------------------------------------------------------------------------

--12. Which are the top 5 locations with the highest number of cancellations?

select * from Ola_rides

select top 5 pickup_location,
count(*) as total_cancellations
from Ola_rides
where booking_status <> 'Success'
group by pickup_location
order by total_cancellations desc

---------------------------------------------------------------------------------------------------

--13. Find the Maxium and Minimum driver ratings for prime bookings?

select * from Ola_rides

select vehicle_type,max(driver_ratings) as max_rating,min(driver_ratings) as min_rating
from Ola_rides
where vehicle_type like '%prime%' and
booking_status ='Success'
group by vehicle_type


-- This section contains analysis related to cancelled bookings



--1. What is the total number of cancelled_rides?

select * from Ola_rides

select count(*) as total_count from Ola_rides
where booking_status<> 'Success'


---------------------------------------------------------------------------------------------------


--2. What % of rides are not completed?

select * from Ola_rides

select 
format
(count(case when
booking_status <> 'success' then 1 
end ) * 100.0 / count(*),'N2')+ '%' as  not_completed_percentage
from Ola_rides


---------------------------------------------------------------------------------------------------


--3. How many bookings fall under each booking status category?

select * from Ola_rides

select booking_status,
count(*) as total_number
from Ola_rides
group by booking_status


---------------------------------------------------------------------------------------------------

--4.What are the top reasons for ride cancellation?

select * from Ola_rides

select Canceled_Rides_by_Customer,
Canceled_Rides_by_Driver,booking_status,
count(*) as total_cancelled
from Ola_rides
where booking_status <> 'Success'
group by Canceled_Rides_by_Customer,
Canceled_Rides_by_Driver,booking_status
order by total_cancelled desc


---------------------------------------------------------------------------------------------------

--5. At what hour do most cancellations happen?

select * from Ola_rides

select 
case when 
	datepart(hour,time) between 0 and 4 then 'Night' 
	when datepart(hour,time) between 5 and 11 then 'Morning'
	when datepart(hour, time) between 12 and 17 then 'Afternoon'
	when datepart(hour,time) between 18 and 23 then 'Evening'
	end as time,
	count(*) as total_cancelled_bookings
	from Ola_rides
	group by case when 
	datepart(hour,time) between 0 and 4 then 'Night' 
	when datepart(hour,time) between 5 and 11 then 'Morning'
	when datepart(hour, time) between 12 and 17 then 'Afternoon'
	when datepart(hour,time) between 18 and 23 then 'Evening'
	end 
	order by total_cancelled_bookings desc

--note: we are not mentioning booking_status like '%cancelled%' due to we have another option in table 
--(Driver Not Found).


---------------------------------------------------------------------------------------------------

--6. Evaluation of cancellation patterns between drivers and customers

select * from Ola_rides

select 
'customer' as cancelled_by,
count(*) as Total_cancellations
from Ola_rides
where Canceled_Rides_by_Customer <> '-'

union all

select 
'driver' as cancelled_by,
count(*) as Total_cancellations
from Ola_rides
where Canceled_Rides_by_driver <> '-'
order by Total_cancellations desc


---------------------------------------------------------------------------------------------------

--7. Identify the top 5 vehicle types with the highest number of incomplete bookings.

select * from Ola_rides

select  top 5 Vehicle_Type,
count(*) as total
from Ola_rides
where booking_status <> 'success'
group by Vehicle_Type
order by total desc


---------------------------------------------------------------------------------------------------

--8. How much revenue is lost due to cancellations?

select * from Ola_rides


select sum(booking_value) as revenue_lost
from Ola_rides
where booking_status<>'success'


---------------------------------------------------------------------------------------------------


--9. What percentage of total revenue is lost due to ride cancellations?

select format(sum(
case when booking_status <>'success' then booking_value
else 0
end )* 100.0/ sum(booking_value), 'N2') + ' %' as revenue_loss_percentage
from Ola_rides






