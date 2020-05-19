using Santander.SQL.IServices;
using Santander.SQL.Models;
using Santander.SQL.Models.SearchCriterias;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.DbServices
{
    

    public class DbAccountOperationService : IAccountOperationService
    {
        // System.Data.SqlClient - stara wersja biblioteki
        // Microsoft.Data.SqlClient - nowa wersja biblioteki, zalecana

        private readonly SqlConnection connection;

        private static string Map2(OperationStatus operationStatus)
        {
            switch(operationStatus)
            {
                case OperationStatus.OK: return "OK";
                case OperationStatus.KO: return "KO";
                case OperationStatus.Exception: return "EX";

                default: throw new NotSupportedException(operationStatus.ToString());
            }
        }

        private static string Map(OperationStatus operationStatus)
        {
            return operationStatus.ToString().Substring(0, 2).ToUpper();
        }

        public DbAccountOperationService(SqlConnection connection)
        {
            this.connection = connection;
        }

        public void Remove(int id)
        {
            throw new NotImplementedException(); 
        }

        public void Add(AccountOperation accountOperation)
        {
            string sql = "INSERT INTO Santander.AccountOperations VALUES (@AccountOperationId, @Account, @OperationDate, @OperationTypeId, @OperationStatus)";

            SqlCommand command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@AccountOperationId", accountOperation.Id);
            command.Parameters.AddWithValue("@Account", accountOperation.Account);
            command.Parameters.AddWithValue("@OperationDate", accountOperation.OperationDate);
            command.Parameters.AddWithValue("@OperationTypeId", accountOperation.OperationType.Id);
            command.Parameters.AddWithValue("@OperationStatus", Map(accountOperation.OperationStatus));

            connection.Open();
            command.ExecuteNonQuery();
            connection.Close();
        }

        public IEnumerable<AccountOperation> Get(AccountOpeationSearchCriteria searchCriteria)
        {
            throw new NotImplementedException();
        }
    }
}
