--create database msbiskills
--go
--use msbiskills
--go

CREATE TABLE lag
(
BusinessEntityID INT
,SalesYear   INT
,CurrentQuota  DECIMAL(20,4)
)
GO
 
INSERT INTO lag
SELECT 275 , 2005 , '367000.00'
UNION ALL
SELECT 275 , 2005 , '556000.00'
UNION ALL
SELECT 275 , 2006 , '502000.00'
UNION ALL
SELECT 275 , 2006 , '550000.00'
UNION ALL
SELECT 275 , 2006 , '1429000.00'
UNION ALL
SELECT 275 , 2006 ,  '1324000.00'

--------------- T-SQL 1
;with A as (
	select 
		BusinessEntityID, 
		SalesYear, 
		CurrentQuota,
		(ROW_NUMBER() over(order by CurrentQuota) - 1) as Rownum
	from lag
),
B as (
	select 
		BusinessEntityID, 
		SalesYear, 
		CurrentQuota,
		ROW_NUMBER() over(order by CurrentQuota) as Rownum
	from lag
)
select A.BusinessEntityID, A.SalesYear, A.CurrentQuota, isNull(B.CurrentQuota, 0)
from A left join B
on A.Rownum = B.Rownum

--------------- T-SQL 2
;with A as (
	select 
		BusinessEntityID, 
		SalesYear, 
		CurrentQuota,
		ROW_NUMBER() over(order by CurrentQuota) as Rownum
	from lag
)
select y.BusinessEntityID, y.SalesYear, y.CurrentQuota, isNull(x.CurrentQuota, 0)
from A x right join A y 
on x.Rownum = (y.Rownum + 1)

--------------- T-SQL 2
CREATE TABLE EmpBirth
(
 EmpId INT  IDENTITY(1,1) 
,EmpName VARCHAR(50) 
,BirthDate DATETIME 
)
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983'
 
SELECT EmpId,EmpName,BirthDate FROM EmpBirth
where month(BirthDate) = 05 and day(BirthDate) between 7 and 15

--------------- T-SQL 4
CREATE TABLE [Movie]
(
 
[MName] [varchar] (10) NULL,
[AName] [varchar] (10) NULL,
[Roles] [varchar] (10) NULL
)
 
INSERT INTO Movie(MName,AName,Roles)
SELECT 'A','Amitabh','Actor'
UNION ALL
SELECT 'A','Vinod','Villan'
UNION ALL
SELECT 'B','Amitabh','Actor'
UNION ALL
SELECT 'B','Vinod','Actor'
UNION ALL
SELECT 'D','Amitabh','Actor'
UNION ALL
SELECT 'E','Vinod','Actor'
 
;with A as (
	SELECT MName , AName , Roles FROM Movie
	where (AName = 'Amitabh' or AName = 'Vinod') and roles = 'Actor'
)
select x.MName, x.AName, x.Roles from A as x
inner join A y on x.Mname = y.MName and x.AName != y.AName

--------------- T-SQL 5
CREATE TABLE PQ
(
ID INT
,Name VARCHAR(10)
,Typed VARCHAR(10)
)
 
--Insert data
INSERT INTO PQ(ID,Name,Typed) VALUES  (1,'P',NULL) , (1,NULL,'Q')
 
--Verify data
SELECT distinct
	ID,
	(select name from PQ where name is not null),
	(select typed from PQ where typed is not null)
FROM  PQ

--------------- T-SQL 6
CREATE TABLE NthHighest
(
 Name  varchar(5)  NOT NULL,
 Salary  int  NOT NULL
)
 
INSERT INTO  NthHighest(Name, Salary)
VALUES
('e5', 45000),
('e3', 30000),
('e2', 49000),
('e4', 36600),
('e1', 58000)
 

 create function dbo.getNth(@x int)
 returns table
 as
 return (
	with A as (
		SELECT Name,Salary, ROW_NUMBER() over(order by salary desc) as rownum 
		FROM NthHighest
	 )
	 select * from A where rownum = @x
 )

 select * from dbo.getNth(2)

 --------------- T-SQL 7
 CREATE TABLE List
(
ID INT
)
GO
 
INSERT INTO List(ID) VALUES (1),(2),(3),(4),(5)

select *, (select sum(id) from List as l2 where l1.id >= l2.id) from List as l1

--------------- T-SQL 8
CREATE TABLE TestMax
(
Year1 INT
,Max1 INT
,Max2 INT
,Max3 INT
)
GO
 
--Insert data
INSERT INTO TestMax 
VALUES
 (2001,10,101,87)
,(2002,103,19,88)
,(2003,21,23,89)
,(2004,27,28,91)
 
Select Year1, case
	when Max1>Max2 and Max1>Max3 then Max1
	when Max2>Max1 and Max2>Max3 then Max2
	when Max3>Max2 and Max3>Max1 then Max3
	end
FROM TestMax

--------------- T-SQL 9
CREATE TABLE [dbo].[EmpSalaryGreaterManager]
(
[EmpID] [int] NULL,
[EmpName] [varchar](50) NULL,
[EmpSalary] [bigint] NULL,
[MgrID] [int] NULL
)
GO
 
INSERT INTO [EmpSalaryGreaterManager](EmpID,EmpName,EmpSalary,MgrID)
VALUES
(1,    'Pawan',      80000, 4),
(2,    'Dheeraj',    70000, 4),
(3,    'Isha',       100000,       4),
(4,    'Joteep',     90000, NULL),
(5,    'Suchita',    110000,       4)
 
SELECT * FROM [dbo].[EmpSalaryGreaterManager] as a1
where a1.empsalary > (Select a2.empsalary from [dbo].[EmpSalaryGreaterManager] as a2 where a1.mgrid = a2.EmpID)

--------------- T-SQL 10
CREATE TABLE Department
(
DeptID INT
,DeptName VARCHAR(10)
)
GO
 
INSERT INTO Department(DeptID,DeptName)
VALUES
(1,'Finance'),
(2,'IT'),
(3,'HR')
 
SELECT DeptID,DeptName FROM Department
 
CREATE TABLE Emps
(
EmpID INT
,EmpName VARCHAR(50)
,DeptID INT
,EmpSalary FLOAT
)
GO
 
INSERT INTO Emps(EmpID,EmpName,DeptID,EmpSalary) VALUES
(101,'Isha',1,7000),
(111,'Esha',1,8970),
(102,'Mayank',1,8900),
(103,'Ramesh',2,4000),
(104,'Avtaar',2,9000),
(105,'Gopal',3,17000),
(106,'Krishna',3,1000),
(107,'Suchita',3,7000),
(108,'Ranjan',3,17900)
 
;with A as (
	SELECT EmpID, 
		EmpName, 
		DeptID,
		EmpSalary, 
		ROW_NUMBER() over(partition by deptId order by empsalary) as rownum 
	FROM Emps
)
select 
		EmpID, 
		EmpName, 
		(select deptname from Department where Department.DeptID = A.DeptID) as Dep,
		EmpSalary
from A where rownum = 2

--------------- T-SQL 11
CREATE TABLE [dbo].[TestMultipleZero]
(
[A] [int] NULL,
[B] [int] NULL,
[C] [int] NULL,
[D] [int] NULL
)
GO
 
--Insert Data
INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES (0,0,0,1),(0,0,1,0),(0,1,0,0),(1,0,0,0),(0,0,0,0),(1,1,1,0)
 
--Check data
SELECT A,B,C,D FROM [dbo].[TestMultipleZero]
where not (A = 0 and B = 0 and C = 0 and D = 0)

--------------- T-SQL 12
CREATE TABLE GroupbyMultipleColumns
(
ID INT
,Typ VARCHAR(1)
,Value1 VARCHAR(1)
,Value2 VARCHAR(1)
,Value3 VARCHAR(1)
)
GO
 
INSERT INTO GroupbyMultipleColumns(ID,Typ,Value1,Value2,Value3)
VALUES
(1,'I','a','b',''),
(2,'O','a','d','f'),
(3,'I','d','b',''),
(4,'O','g','l',''),
(5,'I','z','g','a'),
(6,'I','z','g','a')
 
SELECT Typ, count(Typ) as count FROM GroupbyMultipleColumns
where value1='a' or Value2='a' or value3='a'
group by Typ

--------------- T-SQL 13
CREATE TABLE [dbo].[testGoldRateChange]
(
[dt] [datetime] NULL,
[Rate] [int] NULL
)
GO
 
INSERT INTO [dbo].[testGoldRateChange](dt,Rate)
VALUES
('2014-09-18 06:25:19.897', 27000),
('2014-09-19 06:25:19.897', 27000),
('2014-09-20 06:25:19.897', 31000),
('2014-09-21 06:25:19.897', 31000),
('2014-09-22 06:25:19.897', 31000),
('2014-09-23 06:25:19.897', 32000),
('2014-09-24 06:25:19.897', 31000),
('2014-09-25 06:25:19.897', 32000),
('2014-09-26 06:25:19.897', 27000)
 
;with A as (
	SELECT dt, Rate, isnull(lag(rate) over(order by dt), rate) as LAG FROM [dbo].[testGoldRateChange]
),
X as (
	select dt, Rate, lag, 0 as n 
	from A where day(dt) = 18
	union all
	select A.dt, A.Rate, A.lag, case when A.rate = A.lag then X.n else X.n+1 end 
	from A inner join X on A.dt = dateadd(day, 1, X.dt)
)
select min(dt), max(dt), rate from X group by rate, n

--------------- T-SQL 15
CREATE TABLE WorkOrders
(
WorkOrderID CHAR(5) NOT NULL,
STEP_NBR INTEGER NOT NULL CHECK (step_nbr BETWEEN 0 AND 1000),
STEP_STATUS CHAR(1) NOT NULL CHECK (step_status IN ('C', 'W')), -- complete, waiting
)
GO
 
--Insert Data
INSERT INTO WorkOrders(WorkOrderID,STEP_NBR,STEP_STATUS) VALUES
('AA100', 0, 'C'),
('AA100', 1, 'W'),
('AA100', 2, 'W'),
('AA200', 0, 'W'),
('AA200', 1, 'W'),
('AA300', 0, 'C'),
('AA300', 1, 'C')
GO
 
 
;with A as (
	SELECT WorkOrderID,STEP_NBR,STEP_STATUS FROM WorkOrders
	where (step_nbr = 0 and STEP_STATUS = 'C') or (step_nbr != 0 and STEP_STATUS = 'W')
)
select workorderid from A 
group by workorderid
having count(workorderid) > 1

--------------- T-SQL 16
CREATE TABLE IndAusSeries
(
TeamA VARCHAR(3)
,TeamB VARCHAR(3)
,MatchDate DATETIME
,WinsBy VARCHAR(3)
)
GO
 
--Insert Data
 
INSERT INTO IndAusSeries(TeamA,TeamB,MatchDate,WinsBy)
VALUES
('Ind','Aus','01-10-2014','Ind'),
('Ind','Aus','01-15-2014','Ind'),
('Ind','Aus','01-19-2014','Ind'),
('Ind','Aus','01-23-2014','Aus'),
('Ind','Aus','01-27-2014','Ind'),
('Ind','Aus','01-31-2014','Ind')
 
---------
with A as 
(
	select TeamA, TeamB, matchDate, winsby, 
	isNull(lag(WinsBy) over(order by matchDate), WinsBy) as laag, 
	ROW_NUMBER() over(order by matchDate) as rowNum
	from IndAusSeries
),
X as (
	Select TeamA, TeamB, matchDate, winsby, laag, rownum, 1 as n
	from A where rownum = 1
		union all
	select A.TeamA, A.TeamB, A.matchDate, A.winsby, A.laag, A.rownum, 
	case when A.WinsBy = A.laag then X.n else X.n + 1 end
	from X inner join A on X.rowNum + 1 = A.rowNum
),
R as (
	select n, count(n) as count from X group by n
),
C as (
	select top 1 n from R order by count desc
)
Select X.TeamA, X.TeamB, X.MatchDate, X.WinsBy
from X inner join C on X.n = C.n

--------------- T-SQL 17
CREATE TABLE Holidays
(
ID INT
,HolidayDate DATETIME
)
GO
 
--Insert Data
INSERT INTO Holidays(ID,HolidayDate)
VALUES
(101,'01/10/2015'),
(102,'01/09/2015'),
(103,'02/19/2015'),
(104,'03/11/2015'),
(105,'04/11/2015')
 
--Verify Data
SELECT ID,HolidayDate FROM Holidays
 
--Create Table
CREATE TABLE CandidateJoining
(
CId VARCHAR(17)
,CJoiningDate DATETIME
)
GO
 
--Insert Data
INSERT INTO CandidateJoining(CId,CJoiningDate)
VALUES
('CJ10101','01/10/2015'),
('CJ10104','01/10/2015'),
('CJ10105','02/18/2015'),
('CJ10121','03/11/2015'),
('CJ10198','04/11/2015')
 
--Verify Data
SELECT 
	CId,
	case when CJoiningDate in (select HolidayDate from Holidays) then DATEADD(day, -1, CJoiningDate) else CJoiningDate end
	FROM CandidateJoining

--------------- T-SQL 18
CREATE TABLE TestCommaUsingCrossApply
(
ID INT
,VALUE VARCHAR(100)
)
GO
 
--Insert Data
 
INSERT INTO TestCommaUsingCrossApply(ID,VALUE)
VALUES
(1,'a,b,c'),
(2,'s,t,u,v,w,x')
 
--Verify Data
select ID,VALUE from TestCommaUsingCrossApply

;with cte as (
	select id, value, left(value, 1) as str1, 1 as n 
	from TestCommaUsingCrossApply
	where id = 1
	union all
	select id, value, SUBSTRING(value, n+1, 1), n+1
	from cte
	where n < len(value)
),
X as (
	select id, value, left(value, 1) as str1, 1 as n 
	from TestCommaUsingCrossApply
	where id = 2
	union all
	select id, value, SUBSTRING(value, n+1, 1), n+1
	from X
	where n < len(value)
)
select id, str1 from cte
where str1 != ','
union all
select id, str1 from X
where str1 != ','

-- Second solution
SELECT 
	ID, 
	value,
	(cast('<A>' + REPLACE(value, ',', '</A><A>') + '</A>' as xml)).value('A[1]', 'varchar(1)')
from TestCommaUsingCrossApply

--------------------------------------------------------------------------------------------------------- T-SQL 19
CREATE TABLE TestSplitData
(
 Start DATETIME
,EndDt DATETIME
,Amount INT
)
GO
 
--Insert Data
 
INSERT INTO TestSplitData(Start,EndDt,Amount)
VALUES
('14-Apr-14','13-May-14',200),
('15-May-14','16-Jun-14',320)
 
--Verify Data
 
SELECT Start,EndDt,Amount FROM TestSplitData

;with A as (
	select Start, enddt, Amount/2 as amt from TestSplitData
	union all
	select Start, enddt, Amount/2 as amt from TestSplitData
),
B as (
	select *, row_number() over(partition by amt order by amt) rm from A 
),
C as (
	select case when rm=1 then start else enddt end as newdt, amt, rm from B
), D as (
	select 
		cast(newdt as date) startDt,
		EOMONTH(newdt) as endDt,
		amt, rm
	from C where rm=1
	union all
	select 
		cast(DATEADD(DAY, 1 - DAY(newdt), newdt) as date) as startDt,
		cast(newdt as date) endDt,
		amt, rm
	from C where rm=2
)
select * from D order by amt

--------------------------------------------------------------------------------------------------------- T-SQL 20
CREATE TABLE dbo.AlternateMaleFemale
(
ID INT
,NAME VARCHAR(10)
,GENDER VARCHAR(1)
)
GO
 
--Insert data
INSERT INTO dbo.AlternateMaleFemale(ID,NAME,GENDER)
VALUES
(1,'Neeraj','M'),
(2,'Mayank','M'),
(3,'Pawan','M'),
(4,'Gopal','M'),
(5,'Sandeep','M'),
(6,'Isha','F'),
(7,'Sugandha','F'),
(8,'kritika','F')
 
--Verify Data
;with A as (
	SELECT ID,NAME,GENDER, row_number() over(partition by gender order by id) as rm
	FROM AlternateMaleFemale
)
Select * from A order by rm, gender desc

--------------------------------------------------------------------------------------------------------- T-SQL 22

CREATE TABLE TestTable 
(
  StudentName VARCHAR(100)
, Course VARCHAR(100)
, Instructor VARCHAR(100)
, RoomNo VARCHAR(100)
)
GO
 
-- Populate table
 
INSERT INTO TestTable (StudentName, Course, Instructor, RoomNo)
SELECT 'Mark', 'Algebra', 'Dr. James', '101'
UNION ALL
SELECT 'Mark', 'Maths', 'Dr. Jones', '201'
UNION ALL
SELECT 'Joe', 'Algebra', 'Dr. James', '101'
UNION ALL
SELECT 'Joe', 'Science', 'Dr. Ross', '301'
UNION ALL
SELECT 'Joe', 'Geography', 'Dr. Lisa', '401'
UNION ALL
SELECT 'Jenny', 'Algebra', 'Dr. James', '101'
GO
 
-- Check orginal data
 
	SELECT StudentName, string_agg(concat (Course, Instructor, 'in Room No', RoomNo),',')
	FROM TestTable group by StudentName

--------------------------------------------------------------------------------------------------------- T-SQL 23
	 
CREATE TABLE Test2DistinctCount
(
a Int
,b Int
)
Go
 
--Insert Data
 
INSERT INTO Test2DistinctCount VALUES
(1,1) , (1,2) , (1,3) , (1,1)
 
--Verify Data
 
SELECT distinct a,b FROM Test2DistinctCount

--------------------------------------------------------------------------------------------------------- T-SQL 24

CREATE TABLE EmployeeDlts(
ID INT,
Name VARCHAR(10)
)
GO
 
INSERT INTO EmployeeDlts(ID,Name)
SELECT 1,'Pawan'  UNION ALL
SELECT 2,'Neeraj' UNION ALL
SELECT 3,'Isha'
GO
 
CREATE TABLE EmployeeSkills(
ID INT,
Skill VARCHAR(10)
)
GO
 
INSERT INTO EmployeeSkills(ID,Skill)
SELECT 1,'SQL'  UNION ALL
SELECT 1,'MSBI'  UNION ALL
SELECT 2,'SQL' UNION ALL
SELECT 2,'SSRS'
 
CREATE TABLE EmployeeProject(
ID INT,
Project VARCHAR(15)
)
GO
 
INSERT INTO EmployeeProject(ID,Project)
SELECT 1,'Microsoft'  UNION ALL
SELECT 1,'Google'  UNION ALL
SELECT 1,'HortonWorks' UNION ALL
SELECT 2,'Microsoft'

select * from EmployeeProject
select * from EmployeeDlts
select * from EmployeeSkills

;with cte as (
	select en.id, name, project 
	from EmployeeProject as ep 
	join EmployeeDlts as en
	on ep.id = en.id
)
select distinct cte.id, name, project, es.skill
from cte right join EmployeeSkills as es
on cte.id = es.id

--------------------------------------------------------------------------------------------------------- T-SQL 25

CREATE TABLE [dbo].[TheCompanyCode]
(
[A] [int] NULL,
[B] [int] NULL,
[C] [int] NULL,
[CompanyCode] [varchar](100) NULL,
[GL] [varchar](100) NULL
)
GO
 
--Insert Data
 
INSERT INTO TheCompanyCode(A,B,C,CompanyCode,GL)
VALUES
(1,    1,     1,     'AA',  001),
(1,    1,     2,     'AA',  002),
(1,    1,     3,     'AA',  003),
(1,    1,     4,     'AA',  004),
(2,    2,     1,     'BB',  001),
(2,    2,     2,     'BB',  002)
 
--Verify Data
 
;with CTE as (
	SELECT 
		A, lag(A) over(order by A) as A2,
		B, lag(B) over(order by A) as B2,
		C, lag(C) over(order by A) as C2,
		CompanyCode, lag(CompanyCode) over(order by A) as Code2,
		GL, lag(GL) over(order by A) as GL2
	FROM TheCompanyCode
)
select 
	case when A = A2 then NULL else A end as A,
	case when B = B2 then NULL else B end as B,
	case when C = C2 then NULL else C end as C,
	case when CompanyCode = Code2 then NULL else CompanyCode end as CompanyCode,
	case when GL = GL2 then NULL else GL end as GL
from CTE


--------------------------------------------------------------------------------------------------------- T-SQL 26

CREATE TABLE [dbo].[MissingValue]
(
[Value] [varchar](1) NULL,
[ayValue] [int] NULL
)
GO
 
--Insert Data
 
INSERT INTO [dbo].[MissingValue](Value,ayValue)
VALUES
('A',  1),
('',   23),
('',   21),
('',   22),
('B',  34),
('',   31),
('',   89),
('C',  222),
('', 10)
 
--Verify Data
 
 
SELECT Value, case when Value='' then 'A' else Value end, ayValue, ROW_NUMBER() over(order by (select 1)) FROM [MissingValue]


--------------------------------------------------------------------------------------------------------- T-SQL 27

CREATE TABLE [dbo].[TwoDecimal]
(
[Val] Money
)
GO
 
 
--Insert Data
 
INSERT INTO
[TwoDecimal]
VALUES
(100.119),
(1.119),
(111.119),
(81.115),
(90.114),
(100.110),
(100.000),
(100.001),
(100.019)
 
--Verify Data
 
;with cte as (
	SELECT 
		Cast(Val as Varchar) as stVal
	FROM [TwoDecimal]
)
Select 
	stVal, 
	case when 
		Cast(SUBSTRING(stVal, CHARINDEX('.', stVal)+1, len(stVal)) as int) = 0 
		then SUBSTRING(stVal, 0, CHARINDEX('.', stVal))
		else stVal
	end
from cte

--------------------------------------------------------------------------------------------------------- T-SQL 28

CREATE TABLE DeleteDup
(
ID INT
)
Go
 
--Insert Data
INSERT INTO DeleteDup VALUES(1),(2),(1)
 
--Verify Data
SELECT distinct ID FROM DeleteDup

--------------------------------------------------------------------------------------------------------- T-SQL 29

--Create Table
CREATE TABLE testMultipleValues
(
ID int
,Name varchar(100)
)
GO
 
--Insert Data
INSERT INTO testMultipleValues(ID,Name)
VALUES
(1,'a,b,c,d,e'),
(2,'a,b'),
(3,'c,d'),
(4,'e'),
(5,'f')
 
--Verify Data

SELECT 
    t.ID, 
    upper(value) AS Name
FROM 
    testMultipleValues AS t
CROSS APPLY 
    STRING_SPLIT(t.Name, ',');

--------------------------------------------------------------------------------------------------------- T-SQL 30


CREATE TABLE PatientProblem
(
PatientID INT,
AdmissionDate DATETIME,
DischargeDate DATETIME,
Cost MONEY
)
GO
 
--Insert Data
INSERT INTO PatientProblem(PatientID,AdmissionDate,DischargeDate
,Cost)
VALUES
(1009,'2014-07-27','2014-07-31',1050.00),
(1009,'2014-08-01','2014-08-23',1070.00),
(1009,'2014-08-31','2014-08-31',1900.00),
(1009,'2014-09-01','2014-09-14',1260.00),
(1009,'2014-12-01','2014-12-31',2090.00),
(1024,'2014-06-07','2014-06-28',1900.00),
(1024,'2014-06-29','2014-07-31',2900.00),
(1024,'2014-08-01','2014-08-02',1800.00)
 
--Verify Data
;with A as (
	SELECT 
		PatientID,
		AdmissionDate,
		DischargeDate,
		lead(AdmissionDate) over(order by (select 1)) as newAdmDate, 
		lag(dateAdd(Day, 1, DischargeDate)) over(order by (select 1)) as newDisDate, 
		AdmissionDate as regAdmDate,
		lag(dateAdd(Day, 1, DischargeDate)) over(order by (select 1)) as regDisDate, 
		Cost 
	FROM PatientProblem
)
Select PatientID,
	   AdmissionDate,
	   DischargeDate,
	   case when AdmissionDate = regDisDate then newDisDate else newAdmDate end, 
	   newAdmDate,
	   newDisDate,
	   regAdmDate,
	   regDisDate,
	   Cost
from A   ----------------NOT SOLVED
