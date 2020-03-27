
-- 1.[1pt] Find the name of all restaurants offering Indian cuisine
select name, cuisine
from restaurant
where cuisine = 'Indian';

-- 2.[2pt] Find restaurant names that received a rating of 4 or 5, sort them in increasing order. 
select distinct r1.rid, r1.name, r2.stars
from (select rid, stars from rating where stars = 4 or stars = 5) r2, restaurant r1
where r2.rid = r1.rid
order by r2.stars;

-- 3.[2pt] Find the names of all restaurants that have no rating.
select rid, name
from restaurant
minus
select distinct r.rid, r.name
from restaurant r, rating t
where r.rid = t.rid;

-- 4.[2pt] Some reviewers didn't provide a date with their rating. 
-- Find the names of all reviewers who have ratings with a NULL value for the date. 

select name
from (select * from rating where ratingdate is null) a, reviewer v
where a.vid = v.vid;

-- 5.[4pt] For all cases where the same reviewer rated the same restaurant twice and gave it a higher rating the second time, 
-- return the reviewer's name and the name of the restaurant.

--whole
select rt.rid, rt.vid, rt.stars, name, rt.ratingdate
from rating rt, reviewer rv
where rt.vid = rv.vid;


select r1.vid, count(r1.vid)/2
from rating r1, rating r2
where r1.vid = r2.vid and r1.stars != r2.stars
group by r1.vid
having count(r1.vid) >= 2;


select distinct r1.rid, r1.vid
from rating r1, rating r2
where r1.ratingdate > r2.ratingdate and r1.rid = r2.rid and r1.stars > r2.stars;


select t1.newvid, t1.newrid
from

(select distinct r1.rid as newrid, r1.vid as newvid
from rating r1, rating r2
where r1.ratingdate > r2.ratingdate and r1.rid = r2.rid and r1.stars > r2.stars and r1.vid = r2.vid) t1,
(select r1.vid as newvid, count(r1.vid)/2
from rating r1, rating r2
where r1.vid = r2.vid and r1.stars != r2.stars
group by r1.vid
having count(r1.vid) >= 2) t2

where t1.newvid = t2.newvid;


----final

select res.name as restaurant_name, rev.name as reviewer_name
from
(select t1.newvid as final_vid, t1.newrid as final_rid
from
(select distinct r1.rid as newrid, r1.vid as newvid
from rating r1, rating r2
where r1.ratingdate > r2.ratingdate and r1.rid = r2.rid and r1.stars > r2.stars and r1.vid = r2.vid) t1,
(select r1.vid as newvid, count(r1.vid)/2
from rating r1, rating r2
where r1.vid = r2.vid and r1.stars != r2.stars
group by r1.vid
having count(r1.vid) >= 2) t2
where t1.newvid = t2.newvid) newtable, restaurant res, reviewer rev
where res.rid = newtable.final_rid and rev.vid = newtable.final_vid;



-- 6.[4pt] For each restaurant that has at least one rating, find the highest number of stars that a restaurant received. 
-- Return the restaurant name and number of stars. Sort by restaurant name. 

select r1.name, r2.stars
from restaurant r1, (select rid, max(stars) as stars from rating group by rid) r2
where r1.rid = r2.rid
order by r1.name;


-- 7.[5pt] For each restaurant, return the name and the 'rating spread', 
-- that is, the difference between highest and lowest ratings given to that restaurant. 
-- Sort by rating spread from highest to lowest, then by restaurant name. 

select rid, max(stars), min(stars) from rating group by rid;

select rid, (max(stars)- min(stars)) as rating_spread from rating group by rid;

-- final
select r1.name, r2.rating_spread
from restaurant r1, (select rid, (max(stars)- min(stars)) as rating_spread from rating group by rid) r2
where r1.rid = r2.rid
order by rating_spread  DESC, name;

-- 8.[5pt] Find the difference between the average rating of Indian restaurants and the average rating of Chinese restaurants. 
-- (Make sure to calculate the average rating for each restaurant, 
-- then the average of those averages for Indian and Chinese restaurants. 
-- Don't just calculate the overall average rating for Indian and Chinese restaurants.) Note: The difference can be negative. 


-- the average rating of Indian restaurants
select r1.rid, r1.name, r1.cuisine, avg(r2.stars) as avg_each
from restaurant r1, rating r2
where r1.rid = r2.rid and cuisine = 'Indian'
group by r1.rid, r1.name, r1.cuisine;

-- the average rating of Chinese restaurants
select r1.rid, r1.name, r1.cuisine, avg(r2.stars) as avg_each
from restaurant r1, rating r2
where r1.rid = r2.rid and cuisine = 'Chinese'
group by r1.rid, r1.name, r1.cuisine;


--each avg(Indian)
select avg(avg_each)
from (
select r1.rid, r1.name, r1.cuisine, avg(r2.stars) as avg_each
from restaurant r1, rating r2
where r1.rid = r2.rid and cuisine = 'Indian'
group by r1.rid, r1.name, r1.cuisine);
-- using join
select avg(Ch_avg) 
from ( select avg(stars) as Ch_avg, name 
from rating r1
join restaurant r2 on r1.rid = r2.rid 
where cuisine = 'Indian'
group by r2.rid, r2.name, r2.cuisine );

--each avg(Chinese)
select avg(avg_each)
from (
select r1.rid, r1.name, r1.cuisine, avg(r2.stars) as avg_each
from restaurant r1, rating r2
where r1.rid = r2.rid and cuisine = 'Chinese'
group by r1.rid, r1.name, r1.cuisine);

-- final answer
select t1.whole_avg - t2.whole_avg as difference
from (
select avg(avg_each) as whole_avg
from (
select r1.rid, r1.name, r1.cuisine, avg(r2.stars) as avg_each
from restaurant r1, rating r2
where r1.rid = r2.rid and cuisine = 'Indian'
group by r1.rid, r1.name, r1.cuisine)
) t1, (
select avg(avg_each) as whole_avg
from (
select r1.rid, r1.name, r1.cuisine, avg(r2.stars) as avg_each
from restaurant r1, rating r2
where r1.rid = r2.rid and cuisine = 'Chinese'
group by r1.rid, r1.name, r1.cuisine)) t2;









