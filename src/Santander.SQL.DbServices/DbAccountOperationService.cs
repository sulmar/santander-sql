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
                case OperationStatus.EX: return "EX";

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


        // FastMember
        //public void BulkCopy(IEnumerable<AccountOperation> operations)
        //{
        //    using (var bcp = new SqlBulkCopy(connection))
        //    using (var reader = ObjectReader.Create(operations, "Id", "Account", "OperationDate"))
        //    {
        //        bcp.DestinationTableName = "Santander.AccountOperations";
        //        bcp.BatchSize = 500;
        //        bcp.WriteToServer(reader);
        //    }
        //}

        public IEnumerable<AccountOperation> Get(AccountOperationSearchCriteria searchCriteria)
        {
            string sql = "SELECT AccountOperationId, Account, OperationDate, OperationTypeId, OperationStatus FROM Santander.AccountOperations WHERE ";

            if (!string.IsNullOrEmpty(searchCriteria.Account))
            {
                sql += "Account like @Account + '%'";
            }

            if (searchCriteria.From.HasValue && searchCriteria.To.HasValue)
            {
                sql += "AND OperationDate BETWEEN @From AND @To";
            }

            SqlCommand command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@Account", searchCriteria.Account);
            command.Parameters.AddWithValue("@From", searchCriteria.From);
            command.Parameters.AddWithValue("@To", searchCriteria.To);

            connection.Open();

            SqlDataReader reader = command.ExecuteReader();

            ICollection<AccountOperation> accountOperations = new List<AccountOperation>();
            
            while(reader.Read())
            {
                yield return Map(reader);
            }

            connection.Close();

        }

        private static AccountOperation Map(SqlDataReader reader)
        {
            AccountOperation accountOperation = new AccountOperation();
            accountOperation.Id = reader.GetInt32(0);
            accountOperation.Account = reader.GetString(1);
            accountOperation.OperationDate = reader.GetDateTime(2);

            int operationTypeId = reader.GetInt32(3);
            accountOperation.OperationType = new OperationType { Id = operationTypeId };

            accountOperation.OperationStatus = (OperationStatus)Enum.Parse(typeof(OperationStatus), reader.GetString(4));

            return accountOperation;
        }
    }
}
