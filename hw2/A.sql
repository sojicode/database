-- 1. List car rental companies which have a mileage of at least 27 miles/gallon. 

select rentalcompany, mileage
from bycar
where mileage >= 27;

-- 2. List trip IDs taken on train costing strictly more than $150. 

select tid, travelmode, fare
from trips
where travelmode = 'Train' and fare > 150;

-- 3. Find trip IDs and their fare that are not taken in the US i.e., `Non-US` trips. 

select tid, tripstate, fare
from trips
where tripstate = 'Non-US';

-- 4. Find the business class plane trip IDs that are greater than $1000.

select tid 
from trips
where travelmode = 'Plane' and fare > 1000
minus
select tid 
from byplane 
where class != 'Business';

--final
select trips.tid 
from trips
inner join byplane on trips.tid = byplane.tid
where fare > 1000 and class = 'Business';

-- 5. Find any car trip more expensive than a trip taken on a train in the same state or outside the country.

select t1.*
from (select * from trips where travelmode = 'Car') t1, 
     (select * from trips where travelmode = 'Train') t2
where t1.tripstate = t2.tripstate and t1.fare > t2.fare;

--select * from trips where travelmode = 'Car';
--select * from trips where travelmode = 'Train'; 


-- 6. List pairs of distinct trips that have exactly the same value of mileage.  
-- (Note a pair of distinct trips is of the format: (TID1, TID2))
-- (This distinct pair is not the same as the pair (TID2, TID1))

--answer
select distinct c1.tid, c2.tid
from bycar c1, bycar c2 
where c1.tid != c2.tid and c1.mileage = c2.mileage;


select c1.*, c2.*
from bycar c1, bycar c2;

select distinct c1.*, c2.*
from bycar c1, bycar c2;


select c1.tid, c2.tid
from bycar c1, bycar c2 
where c1.tid != c2.tid and c1.mileage = c2.mileage
group by c1.tid, c2.tid;

-- 7. List pairs of distinct train trips that do not have the same speed.  

-- (other way, check)
select distinct t1.tid, t1.type, t1.trainspeed, t2.tid, t2.type, t2.trainspeed
from bytrain t1, bytrain t2
where t1.tid != t2.tid and t1.trainspeed != t2.trainspeed;

--(same train speed)
select distinct t1.tid, t1.type, t1.trainspeed, t2.tid, t2.type, t2.trainspeed
from bytrain t1, bytrain t2 
where t1.tid != t2.tid 
minus
select distinct t1.tid, t1.type, t1.trainspeed, t2.tid, t2.type, t2.trainspeed
from bytrain t1, bytrain t2
where t1.tid != t2.tid and t1.trainspeed != t2.trainspeed;

-- final : do not have the same speed
select distinct t1.tid, t2.tid
from bytrain t1, bytrain t2 
where t1.tid != t2.tid 
minus
select distinct t1.tid, t2.tid
from bytrain t1, bytrain t2
where t1.tid != t2.tid and t1.trainspeed = t2.trainspeed;

-- 8. Find those pair of trips in the same state with the same mode of travel. 
-- List such pairs only once. In other words, given a pair (TID1,TID2) do NOT list (TID2,TID1).

--(still there are (TID1,TID2) and (TID2,TID1) 
select t1.tid, t1.tripstate, t1.travelmode, t2.tid, t2.tripstate, t2.travelmode 
from trips t1, trips t2
where t1.tid != t2.tid and t1.tripstate = t2.tripstate and t1.travelmode = t2.travelmode;

select t1.tid, t2.tid 
from trips t1
inner join trips t2 on t1.tid != t2.tid and t1.tripstate = t2.tripstate and t1.travelmode = t2.travelmode;

-- final: given a pair (TID1,TID2) do NOT list (TID2,TID1)
select t1.tid, t2.tid 
from trips t1, trips t2
where t1.tid < t2.tid and t1.tripstate = t2.tripstate and t1.travelmode = t2.travelmode;


-- 9. Find a state in which trips have been taken by all three modes of transportation:  train, plane, and car. 

select distinct t1.tripstate
from trips t1, trips t2, trips t3
where t1.tripstate = t2.tripstate and t1.travelmode != t2.travelmode and t2.tripstate = t3.tripstate and t2.travelmode != t3.travelmode
and t1.tripstate = t3.tripstate and t1.travelmode != t3.travelmode;


-- 10. Find the details of a) the most costly trip, b) the cheapest trip, regardless of the travel mode. 
-- Write two separate queries for (a) and (b). 
-- Write both (a) and (b) as a self-join with basic SQL operators. 
-- (Filter, Project, Rename, Join (cross-join, natural join), Union, Intersect, and Difference). 
-- Do not use ALL, ANY, DISTINCT, GROUP BY, HAVING, MAX, MIN, ORDER BY.

-- a) the most costly trip, regardless of the travel mode

select * from trips
minus 
select t1.* from trips t1, trips t2 where t1.fare < t2.fare;

--fianl a)
select t1.tid, t1.fare
from trips t1
left outer join trips t2 ON t1.fare < t2.fare where t2.travelmode is null;

-- b) the cheapest trip, regardless of the travel mode. 

select * from trips
minus 
select t1.* from trips t1, trips t2 where t1.fare > t2.fare;

--fianl b)
select t1.tid, t1.fare
from trips t1
left outer join trips t2 ON t1.fare > t2.fare where t2.travelmode is null;

select t1.*, t2.*
from trips t1
left outer join trips t2 ON t1.fare > t2.fare where t2.travelmode is null;