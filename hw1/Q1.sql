drop table Customer CASCADE CONSTRAINTS;
drop table FullOrder CASCADE CONSTRAINTS;
drop table Product CASCADE CONSTRAINTS;
drop table Request CASCADE CONSTRAINTS;

create table Customer (
 CustomerID        number(3),
 Name              varchar(25),
 Address           varchar(50),
 
 primary key(CustomerID)
);

create table FullOrder (
 OrderID           number(5),
 OrderDate         DATE,
 CustomerID        number(3),
 
 primary key(OrderID),
 foreign key(CustomerID) references Customer(CustomerID)
);


create table Product (
 ProductID         number(2),
 Description       varchar(28),
 Finish            varchar(10),
 Price             FLOAT check ((Price >= 0) and (Price <= 999.99)),
 
 primary key(ProductID)
);

create table Request (
 OrderID           number(5),
 ProductID         number(2),
 Quantity          INT CHECK (1 <= Quantity and Quantity <= 100),
 
 foreign key(OrderID) references FullOrder(OrderID),
 foreign key(ProductID) references Product(ProductID)
);

delete from Customer;
delete from fullorder;
delete from product;
delete from request;


insert into customer VALUES(2, 'CASUAL FURNITURE', 'PLANO, TX');
insert into customer VALUES(6, 'MOUNTAIN GALLERY', 'BOULDER, CO');

insert into fullorder VALUES(1006, '24-MAR-10', 2);
insert into fullorder VALUES(1007, '25-MAR-10', 6);
insert into fullorder VALUES(1008, '25-MAR-10', 6);
insert into fullorder VALUES(1009, '26-MAR-10', 2);

insert into product VALUES(10, 'WRITING DESK', 'OAK', 425);
insert into product VALUES(30, 'DINING TABLE', 'ASH', 600);
insert into product VALUES(40, 'ENTERTAINMENT CENTER', 'MAPLE', 650);
insert into product VALUES(70, 'CHILDRENS DRESSER', 'PINE', 300);

insert into request VALUES(1006, 10, 4);
insert into request VALUES(1006, 30, 2);
insert into request VALUES(1006, 40, 1);
insert into request VALUES(1007, 40, 3);
insert into request VALUES(1007, 70, 2);
insert into request VALUES(1008, 70, 1);
insert into request VALUES(1009, 10, 2);
insert into request VALUES(1009, 40, 1);

select * from Customer;
select * from FullOrder;
select * from Product;
select * from Request;
