set serveroutput on

drop table Restaurant;
drop table Restaurant_Locations;

create table Restaurant(rID int, name varchar2(100), address varchar2(100), cuisine varchar2(100));

insert into Restaurant values(101, 'India House Restaurant', '59 W Grand Ave Chicago, IL 60654', 'Indian');
insert into Restaurant values(102, 'Bombay Wraps', '122 N Wells St Chicago, IL 60606', 'Indian');
insert into Restaurant values(103, 'Rangoli', '2421 W North Ave Chicago, IL 60647', 'Indian');
insert into Restaurant values(104, 'Cumin', '1414 N Milwaukee Ave Chicago, IL 60622', 'Indian');
insert into Restaurant values(105, 'Shanghai Inn', '4723 N Damen Ave Chicago, IL 60625', 'Chinese');
insert into Restaurant values(106, 'MingHin Cuisine', '333 E Benton Pl Chicago, IL 60601', 'Chinese');
insert into Restaurant values(107, 'Shanghai Terrace', '108 E Superior St Chicago, IL 60611', 'Chinese');
insert into Restaurant values(108, 'Jade Court', '626 S Racine Ave Chicago, IL 60607', 'Chinese');


create table Restaurant_Locations 
(
    rId int,
    name varchar2(30),
    street_adress varchar2(40),
    city varchar2(20),
    state varchar2(5),
    zipcode int,
    cuisine varchar2(20)

);

 declare
 /* Output variables to hold the result of the query */
    new_rId Restaurant_Locations.rId%Type;
    new_name Restaurant_Locations.name%Type;
    new_stAdress Restaurant_Locations.street_adress%Type;
    new_city Restaurant_Locations.city%Type;
    new_state Restaurant_Locations.state%Type;
    new_zipcode Restaurant_Locations.zipcode%Type;
    new_cuisine Restaurant_Locations.cuisine%Type;
 /* Cursor Declaration */   
 cursor r1Cursor is
         select rId,name,
         regexp_substr(address,'[0-9]{1,} [A-Z]{1,} [A-Z][a-z]{1,} [A-Z][a-z]{1,}') street_Adrress,
         regexp_substr(address,'\w+',1,5) City,
         regexp_substr(address,'\w+',1,6) State,
         regexp_substr(address,'\w+',1,7) Zip,
         cuisine from Restaurant; 
 begin
 open r1Cursor; 
 loop
 
    fetch r1Cursor into new_rId, new_name, new_stAdress, new_city, new_state, new_zipcode, new_cuisine;
    
    if r1Cursor%FOUND then
    
        insert into Restaurant_Locations(rId,name,street_adress,city,state,zipcode,cuisine) 
        values(new_rId,new_name,new_stAdress,new_city,new_state,new_zipcode,new_cuisine);
   
    end if;
    /* If there are no more rows to fetch, exit the loop */
    exit when r1Cursor%NOTFOUND;
    
 end loop;
 DBMS_OUTPUT.PUT_LINE('In total, we fetched ' || r1Cursor%rowcount || ' rows.');
close r1Cursor;
end;
/  

select * from Restaurant_Locations;



