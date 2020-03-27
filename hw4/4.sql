set serveroutput on

DROP TABLE CONTRACT CASCADE CONSTRAINTS; 
DROP TABLE TASK CASCADE CONSTRAINTS; 

CREATE TABLE TASK 
(
    TaskID        CHAR(3),
    TaskName      VARCHAR(20),
    ContractCount NUMERIC(1,0) DEFAULT 0, 
    
    CONSTRAINT PK_TASK PRIMARY KEY (TaskID)
);

CREATE TABLE CONTRACT 
(
    TaskID CHAR(3),
    WorkerID CHAR(7),
    Payment NUMERIC(6,2),
    CONSTRAINT PK_CONTRACT PRIMARY KEY (TaskID, WorkerID),
    CONSTRAINT FK_CONTRACTTASK FOREIGN KEY (TaskID) REFERENCES TASK (TaskID) 
);

INSERT INTO TASK (TaskID, TaskName) VALUES ('333', 'Security' );
INSERT INTO TASK (TaskID, TaskName) VALUES ('322', 'Infrastructure');
INSERT INTO TASK (TaskID, TaskName) VALUES ('896', 'Compliance' );

SELECT * FROM TASK;
COMMIT; 


/* 
1. The first trigger, named NewContract, will fire when a user attempts to INSERT a row into CONTRACT. 
   This trigger will check the value of ContractCount for the corresponding task.
   If ContractCount is less than 3, then there is still room in the task for another worker, 
   so it will allow the INSERT to occur and will increase the value of ContractCount by one. 
   If ContractCount is equal to 3, then the task is full, so it will cancel the INSERT and 
   display an error message stating that the task is full. 
*/

CREATE or REPLACE TRIGGER NewContract before insert on CONTRACT
FOR EACH ROW 
declare conCount TASK.ContractCount%type;
begin 
    select ContractCount into conCount from Task where TaskID = :new.TaskID;
    
    if (conCount < 3) then
        update Task set TASK.ContractCount = TASK.ContractCount+1 WHERE TaskID = :new.TaskID;
        --DBMS_OUTPUT.PUT_LINE('Updated');
        
        
          
    elsif (conCount = 3) then
        DBMS_OUTPUT.PUT_LINE('Error! The task is full so cancel the insert.');
        RAISE_APPLICATION_ERROR(-20000, 'The task is full so cancel the insert.');
        
    end if;
    --EXCEPTION
    --WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE('This would have been an error.');
END; 
/ 

--test
insert into Contract values ('333', '123456', 300.12);
insert into Contract values ('333', '234567', 400.12);
insert into Contract values ('333', '345678', 500.12);
insert into Contract values ('322', '123456', 330.12);
insert into Contract values ('322', '234567', 450.12);
insert into Contract values ('896', '345678', 500.12);
insert into Contract values ('333', '456789', 600.12); --for error message check

SELECT * FROM TASK;
SELECT * FROM CONTRACT;


/* 2. The second trigger, named EndContract, will fire when a user attempts to DELETE one or more rows 
   from CONTRACT. This trigger will update the values of ContractCount for any affected tasks to make sure 
   they are accurate after the rows are deleted, by decreasing the value of ContractCount by one each time 
   a worker is removed from a task.   */
CREATE or REPLACE TRIGGER EndContract before delete on CONTRACT
FOR EACH ROW 
begin 
    update Task set TASK.ContractCount = TASK.ContractCount-1 WHERE TaskID = :old.TaskID;
   
END; 
/ 

--test
delete from Contract where TaskID = '333' and WorkerID ='123456';

SELECT * FROM TASK;
SELECT * FROM CONTRACT;


/*
3. The third trigger, named NoChanges, will fire when a user attempts to UPDATE one or more rows of CONTRACT. 
   The trigger will cancel the UPDATE and display an error message stating that no updates are permitted 
   to existing rows of CONTRACT. 
   
*/

CREATE or REPLACE TRIGGER NoChanges before update on CONTRACT
FOR EACH ROW 
begin 
    DBMS_OUTPUT.PUT_LINE('No updates are permitted to existing rows of CONTRACT.');
    RAISE_APPLICATION_ERROR(-20000, 'No updates are permitted to existing rows of CONTRACT.');

END; 
/ 

--test
update Contract set Payment = 450.12 where TaskID = '333' and WorkerID = '234567';

SELECT * FROM TASK;
SELECT * FROM CONTRACT;