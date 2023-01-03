Select *
from ny_airbnb 

--How many either entire apt/house and Private rooms there are by borough--
select borough, room_type, count(borough) as NumberofRoomType
from ny_airbnb
where room_type <> 'Shared room'
group by room_type,borough
order by   NumberofRoomType desc

--How many rooms does each borough have available?
select count(room_type) as AmountofRooms, borough
from ny_airbnb
group by borough
order by AmountofRooms desc

--What is the average price of a room in each borough?
select borough, round(avg(price),2) as AvgPrice
from ny_airbnb
group by borough
order by AvgPrice desc

--What is the average price of a room type in NY?
select borough,room_type, round(avg(price),2) as AvgPrice
from ny_airbnb
group by borough,room_type
order by borough
