set serveroutput on

drop table Restaurant;
drop table Reviewer;
drop table Rating;

create table Restaurant(rID int, name varchar2(100), address varchar2(100), cuisine varchar2(100));
create table Reviewer(vID int, name varchar2(100));
create table Rating(rID int, vID int, stars int, ratingDate date);

insert into Restaurant values(101, 'India House Restaurant', '59 W Grand Ave Chicago, IL 60654', 'Indian');
insert into Restaurant values(102, 'Bombay Wraps', '122 N Wells St Chicago, IL 60606', 'Indian');
insert into Restaurant values(103, 'Rangoli', '2421 W North Ave Chicago, IL 60647', 'Indian');
insert into Restaurant values(104, 'Cumin', '1414 N Milwaukee Ave Chicago, IL 60622', 'Indian');
insert into Restaurant values(105, 'Shanghai Inn', '4723 N Damen Ave Chicago, IL 60625', 'Chinese');
insert into Restaurant values(106, 'MingHin Cuisine', '333 E Benton Pl Chicago, IL 60601', 'Chinese');
insert into Restaurant values(107, 'Shanghai Terrace', '108 E Superior St Chicago, IL 60611', 'Chinese');
insert into Restaurant values(108, 'Jade Court', '626 S Racine Ave Chicago, IL 60607', 'Chinese');

insert into Reviewer values(2001, 'Sarah M.');
insert into Reviewer values(2002, 'Daniel L.');
insert into Reviewer values(2003, 'B. Harris');
insert into Reviewer values(2004, 'P. Suman');
insert into Reviewer values(2005, 'Suikey S.');
insert into Reviewer values(2006, 'Elizabeth T.');
insert into Reviewer values(2007, 'Cameron J.');
insert into Reviewer values(2008, 'Vivek T.');

insert into Rating values( 101, 2001, 2, DATE '2011-01-22');
insert into Rating values( 101, 2001, 4, DATE '2011-01-27');
insert into Rating values( 106, 2002, 4, null);
insert into Rating values( 103, 2003, 2, DATE '2011-01-20');
insert into Rating values( 108, 2003, 4, DATE '2011-01-12');
insert into Rating values( 108, 2003, 2, DATE '2011-01-30');
insert into Rating values( 101, 2004, 3, DATE '2011-01-09');
insert into Rating values( 103, 2005, 3, DATE '2011-01-27');
insert into Rating values( 104, 2005, 2, DATE '2011-01-22');
insert into Rating values( 108, 2005, 4, null);
insert into Rating values( 107, 2006, 3, DATE '2011-01-15');
insert into Rating values( 106, 2006, 5, DATE '2011-01-19');
insert into Rating values( 107, 2007, 5, DATE '2011-01-20');
insert into Rating values( 104, 2008, 3, DATE '2011-01-02');

select * from Restaurant;
select * from Reviewer;
select * from Rating;

/* a. Write a PL/SQL stored procedure that accepts the above input string and 
      inserts new restaurant rating information into the Rating table. 
      If a new user appears, it inserts into the Reviewer table.               
   b. Also, create a table ‘Top5Restaurants’ restaurants in the database as:
      Create table Top5Restaurants(rID int)  
      
   c. Test your procedure and trigger in SQL Developer to insert the following four strings:
      ('Jade Court','Sarah M.', 4, '08/17/2017')
      ('Shanghai Terrace','Cameron J.', 5, '08/17/2017')
      ('Rangoli','Vivek T.',3,'09/17/2017')
      ('Shanghai Inn','Audrey M.',2,'07/08/2017');
      ('Cumin','Cameron J.', 2, '09/17/2017')
*/

drop table NewRestaurantReview;
drop table Top5Restaurants;

create table NewRestaurantReview(RestaurantName varchar2(100), UserName varchar2(100), Rating int, RatingDate date);
create table Top5Restaurants(rId int);

--procedure

CREATE OR REPLACE PROCEDURE addNewRating(
RestaurantName in varchar2,
UserName in varchar2,
Rating in int,
RatingDate in varchar2
)
AS
restaurantID Restaurant.rid%TYPE;
reviewerID   Reviewer.vID%TYPE;
ratingNum    NewRestaurantReview.Rating%TYPE;
beforeVid    Reviewer.vID%TYPE := 1000;

BEGIN

    select rId into restaurantID from restaurant
    where name = RestaurantName;
    
    select count(name) into ratingNum from reviewer
    where name = UserName;
   
    if ratingNum = 0 then
        insert into Reviewer values(reviewerID, UserName);
        beforeVid := reviewerID;
        reviewerID := reviewerID + 1;
        DBMS_OUTPUT.PUT_LINE(UserName || ' added to Reviewer table.');
    else 
        select vId into reviewerID from reviewer
        where name = username;
        DBMS_OUTPUT.PUT_LINE('Reviewer exists');
    end if;
    
    --INSERT INTO rating VALUES(restaurantID , reviewerID, Rating, RatingDate);

    INSERT INTO rating VALUES(restaurantID , reviewerID, Rating, to_date(RatingDate,'mm/dd/YYYY'));       
END;
/

--test procedure
/*
BEGIN
    addNewRating('Jade Court','Sarah M.', 9, '08/17/2017');
    addNewRating('Shanghai Terrace','Cameron J.', 5, '08/17/2017');

END;
/
*/

-- testing
-- select * from Rating;
-- select * from Reviewer;

-- trigger
create or replace trigger in_trigger after insert on rating
begin 
    delete from Top5Restaurants;
    insert into Top5Restaurants(rId) 
    
    select rid 
    from (select * from (select rid, avg(stars) as SStars 
                         from rating group by rid order by rid)
                    order by SStars  DESC)                                    
    where rownum < 6;
end;
/

--test 
begin
    addNewRating('Jade Court','Sarah M.', 4, '08/17/2017');
    addNewRating('Shanghai Terrace','Cameron J.', 5, '08/17/2017');
    addNewRating('Rangoli','Vivek T.',3,'09/17/2017');
    addNewRating('Shanghai Inn','Audrey M.',2,'07/08/2017');
    addNewRating('Cumin','Cameron J.', 2, '09/17/2017');

end;
/

--test
--insert into Rating values( 101, 2001, 9, DATE '2020-11-17');

select * from Rating;
select * from Reviewer;
select * from Top5Restaurants;

