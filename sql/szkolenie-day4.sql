


/*
-- konfiguracja

exec sp_configure 'show advanced options', 1
reconfigure

exec sp_configure 'Ole Automation Procedures', 1
reconfigure

*/
go

-- IXMLHTTPRequest Members
-- https://docs.microsoft.com/en-us/previous-versions/windows/desktop/ms760305(v=vs.85)

declare @url nvarchar(max)
declare @contentType nvarchar(64) 

SET @url = 'http://api.nbp.pl/api/exchangerates/tables/a'
SET @contentType = 'application/json'

declare @response as TABLE(content nvarchar(max))

declare @ret int
declare @token int

exec @ret = sp_OACreate 'MSXML2.XMLHTTP', @token out;

-- print @token;

if @ret <> 0 RAISERROR('Unable to create instance MSXML2.XMLHTTP', 10, 1);

exec @ret = sp_OAMethod @token, 'open', null, 'GET', @url, 'false';
exec @ret = sp_OAMethod @token, 'setRequestHeader', null, 'Accept', @contentType;

--declare @authHeader varchar(200) = 'Basic r3242jhdads';
--exec @ret = sp_OAMethod @token, 'setRequestHeader', null, 'Authorization', @authHeader;

exec @ret = sp_OAMethod @token, 'send';

if @ret <> 0 RAISERROR('Unable to open HTTP connection', 10, 1);

print @ret

insert into @response (content) EXEC sp_OAGetProperty @token, 'responseText'

select content from @response

go

create function dbo.GetRates()
returns @response  TABLE(content nvarchar(max))
as
begin

declare @url nvarchar(max)
declare @contentType nvarchar(64) 

SET @url = 'http://api.nbp.pl/api/exchangerates/tables/a'
SET @contentType = 'application/json'

-- declare @response as TABLE(content nvarchar(max))

declare @ret int
declare @token int

exec @ret = sp_OACreate 'MSXML2.XMLHTTP', @token out;

-- print @token;

-- if @ret <> 0 RAISERROR('Unable to create instance MSXML2.XMLHTTP', 10, 1);

exec @ret = sp_OAMethod @token, 'open', null, 'GET', @url, 'false';
exec @ret = sp_OAMethod @token, 'setRequestHeader', null, 'Accept', @contentType;

--declare @authHeader varchar(200) = 'Basic r3242jhdads';
--exec @ret = sp_OAMethod @token, 'setRequestHeader', null, 'Authorization', @authHeader;

exec @ret = sp_OAMethod @token, 'send';

-- if @ret <> 0 RAISERROR('Unable to open HTTP connection', 10, 1);

-- print @ret

insert into @response (content) EXEC sp_OAGetProperty @token, 'responseText'


return

end


-- 



-- za³adowanie pliku do zmiennej

-- "C:\temp\santander\nbp-response.json"

declare @json nvarchar(max)

SELECT @json = BulkColumn
 FROM OPENROWSET (BULK 'C:\temp\santander\nbp-response.json', SINGLE_CLOB) as j

select @json


-- za³adowanie pliku do tabeli

SELECT BulkColumn
  INTO #temp
   FROM OPENROWSET (BULK 'C:\temp\santander\nbp-response.json', SINGLE_CLOB) as j

select * from #temp

go

declare @json nvarchar(max)
set @json = '{
	"table":"A",
	"no":"097/A/NBP/2020",
	"effectiveDate":"2020-05-20",
	"bank": { "shortname": "NBP", "name":"Narodowy Bank Polski", "address": { "city": "Wroclaw", "street":"Dworcowa"} },
	"rates":[
		{"currency":"bat (Tajlandia)","code":"THB","mid":0.1307},
		{"currency":"dolar amerykañski","code":"USD","mid":4.1619},
		{"currency":"dolar australijski","code":"AUD","mid":2.7233},
		{"currency":"dolar Hongkongu","code":"HKD","mid":0.5370},
		{"currency":"dolar kanadyjski","code":"CAD","mid":2.9883},
		{"currency":"dolar nowozelandzki","code":"NZD","mid":2.5394},{"currency":"dolar singapurski","code":"SGD","mid":2.9364},{"currency":"euro","code":"EUR","mid":4.5540},{"currency":"forint (Wêgry)","code":"HUF","mid":0.013015},{"currency":"frank szwajcarski","code":"CHF","mid":4.3013},{"currency":"funt szterling","code":"GBP","mid":5.0962},{"currency":"hrywna (Ukraina)","code":"UAH","mid":0.1565},{"currency":"jen (Japonia)","code":"JPY","mid":0.038665},{"currency":"korona czeska","code":"CZK","mid":0.1659},{"currency":"korona duñska","code":"DKK","mid":0.6108},{"currency":"korona islandzka","code":"ISK","mid":0.029099},{"currency":"korona norweska","code":"NOK","mid":0.4165},{"currency":"korona szwedzka","code":"SEK","mid":0.4308},{"currency":"kuna (Chorwacja)","code":"HRK","mid":0.6009},{"currency":"lej rumuñski","code":"RON","mid":0.9403},{"currency":"lew (Bu³garia)","code":"BGN","mid":2.3284},{"currency":"lira turecka","code":"TRY","mid":0.6141},{"currency":"nowy izraelski szekel","code":"ILS","mid":1.1859},{"currency":"peso chilijskie","code":"CLP","mid":0.005083},{"currency":"peso filipiñskie","code":"PHP","mid":0.0821},{"currency":"peso meksykañskie","code":"MXN","mid":0.1771},{"currency":"rand (Republika Po³udniowej Afryki)","code":"ZAR","mid":0.2292},{"currency":"real (Brazylia)","code":"BRL","mid":0.7230},{"currency":"ringgit (Malezja)","code":"MYR","mid":0.9556},{"currency":"rubel rosyjski","code":"RUB","mid":0.0577},{"currency":"rupia indonezyjska","code":"IDR","mid":0.00028289},{"currency":"rupia indyjska","code":"INR","mid":0.054904},{"currency":"won po³udniowokoreañski","code":"KRW","mid":0.003381},{"currency":"yuan renminbi (Chiny)","code":"CNY","mid":0.5856},{"currency":"SDR (MFW)","code":"XDR","mid":5.6789}
		]}'

-- select @json

-- select ISJSON(@json)

-- Pobranie wartoœci pola skalarnego
-- select JSON_VALUE(@json, '$.effectiveDate')

--select JSON_VALUE(@json, 'strict $.bank.name')

--select JSON_VALUE(@json, 'strict $.bank.address.city')

-- tryby:
-- strict - wyœwietla informacje o b³êdzie jeœli nie powiedzie siê parsowanie
-- lax -- zwraca wartoœæ null jeœli nie powiedzie siê parsowanie

-- select JSON_VALUE(@json, 'strict $.rates[1].mid')

-- pobieranie kolekcji (array)

-- select JSON_QUERY(@json, '$.rates')

-- select JSON_QUERY(@json, 'strict $.bank.name')

-- Modyfikacja

-- SELECT JSON_MODIFY(@json, '$.no', '100/A/NBP/2019')

-- SELECT JSON_MODIFY(@json, '$.bank', ' { "shortname": "SPL", "name":"Santander Bank Polska" }')

--SELECT JSON_MODIFY(@json, '$.bank', JSON_QUERY( '{ "shortname": "SPL", "name":"Santander Bank Polska" }') )

--SELECT JSON_MODIFY(@json, '$.effectiveDate', null)

-- Transformacja json do tabeli

-- SELECT * FROM OPENJSON(@json) WHERE [key] = 'no'
go

declare @json nvarchar(max)
set @json = '{
	"table":"A",
	"no":"097/A/NBP/2020",
	"effectiveDate":"2020-05-20",
	"bank": { "shortname": "NBP", "name":"Narodowy Bank Polski", "address": { "city": "Wroclaw", "street":"Dworcowa"} },
	"rates":[
		{"currency":"bat (Tajlandia)","code":"THB","mid":0.1307, "rate" : {"min": 0.1207, "max": 0.1507} },
		{"currency":"dolar amerykañski","code":"USD","mid":4.1619},
		{"currency":"dolar australijski","code":"AUD","mid":2.7233},
		{"currency":"dolar Hongkongu","code":"HKD","mid":0.5370},
		{"currency":"dolar kanadyjski","code":"CAD","mid":2.9883},
		{"currency":"dolar nowozelandzki","code":"NZD","mid":2.5394},{"currency":"dolar singapurski","code":"SGD","mid":2.9364},{"currency":"euro","code":"EUR","mid":4.5540},{"currency":"forint (Wêgry)","code":"HUF","mid":0.013015},{"currency":"frank szwajcarski","code":"CHF","mid":4.3013},{"currency":"funt szterling","code":"GBP","mid":5.0962},{"currency":"hrywna (Ukraina)","code":"UAH","mid":0.1565},{"currency":"jen (Japonia)","code":"JPY","mid":0.038665},{"currency":"korona czeska","code":"CZK","mid":0.1659},{"currency":"korona duñska","code":"DKK","mid":0.6108},{"currency":"korona islandzka","code":"ISK","mid":0.029099},{"currency":"korona norweska","code":"NOK","mid":0.4165},{"currency":"korona szwedzka","code":"SEK","mid":0.4308},{"currency":"kuna (Chorwacja)","code":"HRK","mid":0.6009},{"currency":"lej rumuñski","code":"RON","mid":0.9403},{"currency":"lew (Bu³garia)","code":"BGN","mid":2.3284},{"currency":"lira turecka","code":"TRY","mid":0.6141},{"currency":"nowy izraelski szekel","code":"ILS","mid":1.1859},{"currency":"peso chilijskie","code":"CLP","mid":0.005083},{"currency":"peso filipiñskie","code":"PHP","mid":0.0821},{"currency":"peso meksykañskie","code":"MXN","mid":0.1771},{"currency":"rand (Republika Po³udniowej Afryki)","code":"ZAR","mid":0.2292},{"currency":"real (Brazylia)","code":"BRL","mid":0.7230},{"currency":"ringgit (Malezja)","code":"MYR","mid":0.9556},{"currency":"rubel rosyjski","code":"RUB","mid":0.0577},{"currency":"rupia indonezyjska","code":"IDR","mid":0.00028289},{"currency":"rupia indyjska","code":"INR","mid":0.054904},{"currency":"won po³udniowokoreañski","code":"KRW","mid":0.003381},{"currency":"yuan renminbi (Chiny)","code":"CNY","mid":0.5856},{"currency":"SDR (MFW)","code":"XDR","mid":5.6789}
		]}'

-- SELECT * FROM OPENJSON(@json) 

-- SELECT * FROM OPENJSON(@json, '$.rates') 

-- SELECT * FROM OPENJSON(@json, '$.rates[1]') 

--SELECT * FROM OPENJSON(@json, '$.bank')
--WITH 
--  (
--	[Code] char(3) '$.shortname',
--	[Name] nvarchar(100) '$.name',
--	[City] nvarchar(100) '$.address.city',
--	[Street] nvarchar(100) '$.address.street'
--  )

--SELECT * FROM OPENJSON(@json, '$.rates')
--WITH 
-- (
--   currency nvarchar(100),
--   Code char(3) '$.code',
--   mid  decimal(18, 9),
--   [Min] decimal(18,9) '$.rate.min',
--   [Max] decimal(18,9) '$.rate.max'
-- )


 SELECT * FROM OPENJSON(@json)
 WITH
 (
	[table] char(1),
	[no] varchar(20),
	[effectiveDate] datetime,
	[Code] char(3) '$.bank.shortname',
	Rates nvarchar(max) '$.rates' as json
 )
CROSS APPLY
	 OPENJSON(Rates)
	 WITH
	 (
		   currency nvarchar(100),
		   Code char(3) '$.code',
		   mid  decimal(18, 9)
	 )



-- Zamiana na json


-- wartoœci skalarne

select 
	1 as x,
    2 as y,
	3 as z,
	'Warsaw' as City,
	156.44 as Price
FOR JSON PATH


select 
	1 as x,
    2 as y,
	3 as z,
	'Warsaw' as City,
	156.44 as Price
FOR JSON PATH, without_array_wrapper

select 
	1 as x,
    2 as y,
	3 as z,
	'Warsaw' as City,
	156.44 as Price
FOR JSON PATH, without_array_wrapper, root('location')


-- obiekty
select 
	1 as x,
    2 as y,
	3 as z,

	JSON_QUERY(
		(
			select 
				'red' as foreground,
				'white' as background
			for json path, without_array_wrapper
		) 
	) as color
FOR JSON PATH

SELECT TOP(10) * FROM [Santander].[AccountOperations]
FOR JSON AUTO, root('AccountOperations')


SELECT TOP(5) 
AccountOperationId,
Account,
OperationDate,
OperationStatus,
OperationType.OperationTypeId ,
OperationType.Name 

 FROM [Santander].[AccountOperations] as ao
	inner join [Santander].[OperationTypes] as OperationType
		on ao.OperationTypeId = OperationType.OperationTypeId
FOR JSON AUTO,  without_array_wrapper



SELECT TOP(5) 
AccountOperationId,
Account,
OperationDate,
OperationStatus,
ot.OperationTypeId as 'OperationType.OperationTypeId',
ot.Name as 'OperationType.Name'

 FROM [Santander].[AccountOperations] as ao
	inner join [Santander].[OperationTypes] as ot
		on ao.OperationTypeId = ot.OperationTypeId
FOR JSON PATH, ROOT('AccountOperations')


-- Obs³uga XML

-- Pobranie XML z pliku do zmiennej
declare @xml xml
select @xml = c from openrowset(bulk 'C:\temp\santander\a001z200102.xml', single_blob) as Rates(c)
select @xml

select CONVERT(xml, c) as Content
into [Santander].Rates
from openrowset(bulk 'C:\temp\santander\a001z200102.xml', single_blob) as Rates(c)


select CAST(c as xml) as Content
into [Santander].Rates
from openrowset(bulk 'C:\temp\santander\a001z200102.xml', single_blob) as Rates(c)


drop table #rates
drop table [Santander].Rates

go

declare @xml xml = '?xml version="1.0" encoding="ISO-8859-2"?>
<tabela_kursow typ="A" uid="20a001">
   <numer_tabeli>001/A/NBP/2020</numer_tabeli>
   <data_publikacji>2020-01-02</data_publikacji>
   <pozycja>
      <nazwa_waluty>bat (Tajlandia)</nazwa_waluty>
      <przelicznik>1</przelicznik>
      <kod_waluty>THB</kod_waluty>
      <kurs_sredni>0,1260</kurs_sredni>
   </pozycja>
   <pozycja>
      <nazwa_waluty>dolar amerykañski</nazwa_waluty>
      <przelicznik>1</przelicznik>
      <kod_waluty>USD</kod_waluty>
      <kurs_sredni>3,8000</kurs_sredni>
   </pozycja>
   </tabela_kursow>'


select @xml

select 
	1 as [@x],
	2 as [@y],
	3 as [@z],
	'red' as [color/@foreground],
	'blue' as [color/@background],
	null as [color/@alpha],
	'Gdansk' as City
FOR XML PATH('Location')


 SELECT * FROM [Santander].[AccountOperations] 
 FOR XML AUTO, ELEMENTS


  SELECT 
	AccountOperationId as [@Id],
	Account as [@Account],
	OperationDate,
	OperationTypeId as [Info/OperationType],
	OperationStatus as [Info/Status]
  FROM [Santander].[AccountOperations] 
  FOR XML PATH('Rate'), ROOT('ExchangeRates')

-- przestrzenie nazw (namespace)

WITH XMLNAMESPACES('uri' as ns1)
  SELECT 
	AccountOperationId as [@Id],
	Account as [@Account],
	OperationDate,
	OperationTypeId as [ns1:Info/OperationType],
	OperationStatus as [ns1:Info/Status]
  FROM [Santander].[AccountOperations] 
  FOR XML RAW('Rate'), ROOT('ExchangeRates')

go

  declare @xml xml
  declare @hDoc int

  select @xml = c from openrowset(bulk 'C:\temp\santander\a001z200102.xml', single_blob) as Rates(c)

  exec sp_xml_preparedocument @hdoc output, @xml

  select * from OPENXML(@hDoc, '/tabela_kursow/pozycja', 2)
  WITH	
  (
    typ char(1) '../@typ',  -- poziom wy¿ej, atrybut
    numer_tabeli varchar(20) '../numer_tabeli',
	data_publikacji datetime2 '../data_publikacji',    -- poziom wy¿ej, element
	kod_waluty char(3),
	nazwa_waluty nvarchar(50),
	kurs_sredni varchar(100) 
  )

  exec sp_xml_removedocument @hdoc



  go

  declare @xml xml = '<?xml version="1.0" encoding="utf-8"?><customer>Sulmar</customer>'



  select @xml


  --  Powi¹zanie danych relacyjnych i JSON

  go

  -- Utworzenie tabeli z kolumn¹ w formacie JSON

   create table [Santander].[Stores] (
	storeId int primary key identity,
	title nvarchar(100) not null,
	jsonlocation nvarchar(max)
  )
  



  -- Dodanie regu³y, która weryfikuje zgodnoœæ z formatem JSON

  alter table [Santander].[Stores]
	add constraint [location_json_formatted]
		check (ISJSON(jsonlocation)=1)

-- Dodanie przyk³adowych danych

  insert into [Santander].[Stores] 
	values
		('Store 1', '{"location": {"postcode": "00-123", "street":"Dworcowa", "geo":{ "longitude": 52.12, "latitude": 28.64 } } }'),
		('Store 2', '{"location": {"postcode": "99-033", "street":"Komputerowa", "geo":{ "longitude": 52.82, "latitude": 27.54 } } }'),
		('Store 3', '{"location": {"postcode": "85-100", "street":"Piekna", "geo":{ "longitude": 52.32, "latitude": 27.03 } } }')

		select * from [Santander].[Stores] 
		
  select * from  [Santander].[Stores]
  where JSON_VALUE(jsonlocation, '$.location.street') = 'Dworcowa'

  go

  drop  table [Santander].[Stores]

  create table [Santander].[Stores] (
	storeId int primary key identity,
	title nvarchar(100) not null,
	jsonlocation nvarchar(max),
	ulica as json_value(jsonlocation, '$.location.street'),  -- calculated column
	index ix_ulica(ulica)  -- dodatkowo tworzymy index na kolumnie ulica
  )
	
select * from [Santander].[Stores] 

-- Pobranie wartoœci 

  SELECT 
	title,
	location.street, 
	location.postcode,
	location.lat, 
	location.lon  
FROM  [Santander].[Stores]   
CROSS APPLY 
OPENJSON([Santander].[Stores].jsonlocation, 'lax $.location')   
     WITH (
		street varchar(500),  
		postcode  varchar(500) '$.postcode' ,  
		lon float '$.geo.longitude', 
		lat float '$.geo.latitude'
	)  
     AS location
















































