
use AdventureWorks

go

-- create schema Santander;

go

create table Santander.OperationTypes
(
	OperationTypeId int not null primary key,
	[Name] nvarchar(100)
)

insert into Santander.OperationTypes
	values
		(1, 'Operacja 1'),
		(2, 'Operacja 2'),
		(3, 'Operacja 3')

select * from Santander.OperationTypes

	
create table Santander.AccountOperations
(
  AccountOperationId int not null primary key,
  Account varchar(9) not null,
  OperationDate datetime2 not null,
  OperationTypeId int not null,
  OperationStatus char(2)
)

insert into Santander.AccountOperations
	values 
		(1, '123490104', '2020-05-19 9:58', 1, 'OK'),
		(2, '123490200', '2020-05-18 6:08', 2, 'KO'),
		(3, '123300350', '2020-05-18 17:08', 3, 'EX')

insert into Santander.AccountOperations
	values 
		(5, '123490104', '2020-05-19 9:58', 1, 'XX')


delete from Santander.AccountOperations
	where OperationStatus = 'XX'

update Santander.AccountOperations
set OperationStatus = 'EX'
	where OperationStatus = 'XX'


-- Utworzenie klucza obcego
alter table Santander.AccountOperations
add constraint FK_AccountOperations_OperationTypes foreign key (OperationTypeId)
 references Santander.OperationTypes (OperationTypeId)

alter table Santander.AccountOperations
add constraint Check_OperationStatus
 check ( OperationStatus in ('OK', 'KO', 'EX') )

 alter table Santander.AccountOperations
	 drop constraint Check_OperationStatus




select top 100 * from Santander.AccountOperations

-- delete from Santander.AccountOperations


SELECT 
	AccountOperationId, 
	Account,
	OperationStatus,
	OperationDate

 FROM 
 Santander.AccountOperations 
 WHERE Account = '123469323'

 create nonclustered index IX_AccountOperations_Account
  on Santander.AccountOperations(Account)
	include (OperationStatus, OperationDate)

create nonclustered index IX_AccountOperations_OperationDate
  on Santander.AccountOperations(OperationDate)

drop index IX_AccountOperations_Account
	on Santander.AccountOperations

-- filtered index

create nonclustered index IX_AccountOperations_OperationStatus
 on Santander.AccountOperations(Account, OperationDate)
	where OperationStatus = 'OK'

select * from Santander.AccountOperations
	where OperationStatus = 'OK' and Account like '1234%'


select * from Santander.AccountOperations
	where OperationDate between '2017-01-01' and '2019-01-01'


	



	-- | Account | OperationStatus | 








