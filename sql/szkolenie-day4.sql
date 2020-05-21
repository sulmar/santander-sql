


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
exec @ret = sp_OAMethod @token, 'send';

if @ret <> 0 RAISERROR('Unable to open HTTP connection', 10, 1);

print @ret







 






















