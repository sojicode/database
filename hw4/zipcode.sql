drop table Zipcode;

create table Zipcode
(
    zip  varchar2(6),
    city varchar2(100),
    state varchar2(3),
    latitude decimal(8,6),
    longitude decimal(8,6),
    timezone int,
    dst int
);