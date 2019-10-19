drop table #temp1
drop table #temp2
drop table newtable
drop table checktable

select *,datediff(minute,CONVERT(datetime,start_time,105),CONVERT(datetime,end_time,105)) as trip_duration, ROW_NUMBER() over (order by bike_id, start_time ) as rownum---- trip duration in minute
into #temp1
 FROM [dscomp].[dbo].[LABikeData$]
 where datediff(minute,CONVERT(datetime,start_time,105),CONVERT(datetime,end_time,105))>=1 and -- condition of data preprocessing lower cap=1min and upper cap=24 hours
 datediff(minute,CONVERT(datetime,start_time,105),CONVERT(datetime,end_time,105))<=1440 


select a.*, case when a.trip_route_category='Round Trip' then a.start_station
when a.trip_route_category='One Way' and a.end_station is null then s.start_station  --updating round trip condition and end station null values using bike id
when a.end_station is not null then a.end_station end new_end_station

into dscomp.dbo.checktable
from #temp1 a,#temp1 s
where a.rownum+1=s.rownum

alter table dscomp.dbo.checktable
drop column rownum, end_station    ---removing columns

USE dscomp
GO
sp_RENAME 'checktable.new_end_station', 'end_station' , 'COLUMN' ---renaming the new end_station column
GO

select *
into #temp2 
from checktable
where 

start_station!=3000 and   -- removing the station ids which have no region and virtual station (=3000)
end_station !=3000
/*
start_station not in (3000,4110,4118,4276) and   -- removing the station ids which have no region and virtual station (=3000)
end_station not in (3000,4110,4118,4276)
*/
drop table checktable


-----------------------------------updating lat, lon in newtable-----------------------------------------------------------

  
update #temp2
  set start_lat=34.02589, start_lon=-118.238243                         --- updating start_lat=0 and start_lon=0 with correct lat and lon
  where start_station='4108' and start_lat=0 and start_lon=0

update #temp2
  set start_lat=34.024479, start_lon=-118.393867                          --- updating start_lon=118 with correct lat and lon
  where start_station='3039' and start_lon like '118%'

update #temp2
  set end_lat=34.02589,end_lon=-118.238243								--- updating start_lat=0 and start_lon=0 with max count of lat and lon refer commented code
  where end_station='4108' and end_lat=0 and end_lon=0

/*    select end_station,end_lat,end_lon,count(*)
   from [dscomp].[dbo].newtable
   where end_station='4108'
   group by end_station,end_lat,end_lon
   order by count(*)
    */
 
   select *, case when end_lat is null then (select  top 1 end_lat from #temp1 where end_station=o.end_station group by end_station,end_lat,end_lon order by count(*) desc)
   else end_lat end new_end_lat,
  case when end_lon is null then (select  top 1 end_lon from #temp1  where end_station=o.end_station group by end_station,end_lat,end_lon order by count(*) desc)
   else end_lon end new_end_lon
   
   /*Updating the null values in end_lat, end_lon with the pair which has the maxmim count for a particular end_station*/

   into [dscomp].[dbo].newtable
   from #temp2 o

alter table dscomp.dbo.newtable
drop column end_lat, end_lon    ---removing columns

USE dscomp
GO
sp_RENAME 'newtable.new_end_lat', 'end_lat' , 'COLUMN' ---renaming the new_end_lat column
GO

USE dscomp
GO
sp_RENAME 'newtable.new_end_lon', 'end_lon' , 'COLUMN' ---renaming the new_end_lon column
GO

/*   DEBUG CODE
select top 10 *
from newtable
where new_end_lat is null

  select  end_station,end_lat,end_lon,count(*) as [count]
   from #temp2
  where end_station='3005'
  group by end_station,end_lat,end_lon
   order by count(*) desc

  select  end_station,new_end_lat,new_end_lon,count(*) as [count]
   from newtable
  where end_station='3005'
  group by end_station,new_end_lat,new_end_lon
   order by count(*) desc

      select  *
   from [dscomp].[dbo].newtable
   --where end_lat=0 or end_lon=0 or 
   where end_lat is null or end_lon is null or end_lat=0 or end_lon=0 or start_lat=0 or start_lon=0 or start_lon like '118%'
   order by end_station
*/


------------updating plan duration---------
 
 
update [dscomp].[dbo].newtable
  set plan_duration=30
  where passholder_type='Monthly Pass'

update [dscomp].[dbo].newtable
  set plan_duration=0
  where passholder_type='Walk-up'



   --- updating the missing values in station table based on latitude, longitude and first trip date in [Station_Table$]

update [dscomp].[dbo].[Station_Table$]
  set Region='DTLA'
  where Station_ID in (4110,4118,4276)

  update [dscomp].[dbo].[Station_Table$]
  set Go_live_date='02/12/2018' ,[status]='Active'
  where Station_ID =4276

    update [dscomp].[dbo].[Station_Table$]
  set Go_live_date='01/10/2017' ,[status]='Active'
  where Station_ID in (4110,4118)



select * from newtable 
where start_station in (4110,4118,4276)









