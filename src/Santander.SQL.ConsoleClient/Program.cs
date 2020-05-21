using Santander.SQL.DbServices;
using Santander.SQL.EFServices;
using Santander.SQL.Fakers;
using Santander.SQL.IServices;
using Santander.SQL.Models;
using Santander.SQL.Models.SearchCriterias;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.ConsoleClient
{
    class Program
    {
        static void Main(string[] args)
        {
           // AddAccountOperationTest();

            var stopwatch = Stopwatch.StartNew();

            AddOperationTypeTest();

            UpdateOperationTypeTest();

            // TestEFOperationTypeService();

            // RemoveAccountOperationTest();

            // UpdateAccountOperationTest();

            // GetAccountOperationTest();

            // GetAccountOperationsTest();

            stopwatch.Stop();
            Console.WriteLine("GetAccountOperationsTest " + stopwatch.ElapsedMilliseconds + "ms");


            Console.WriteLine("Press any key to exit.");
            Console.ReadKey();

            
        }

        private static void AddOperationTypeTest()
        {
            string connectionString = GetConnectionString("SULMAR-PC", "AdventureWorks", applicationName: "Santander");

            SantanderContext context = new SantanderContext(connectionString);

            IOperationTypeService operationTypeService = new EFOperationTypeService(context);

            OperationType operationType = new OperationType { Id = 4, Name = "Operacja 4" };
            operationTypeService.Add(operationType);


        }

        private static void TestEFOperationTypeService()
        {
            string connectionString = GetConnectionString("SULMAR-PC", "AdventureWorks", applicationName: "Santander");

            SantanderContext context = new SantanderContext(connectionString);

            IOperationTypeService operationTypeService = new EFOperationTypeService(context);

            OperationType operationType = operationTypeService.Get(1);

        }

        private static void UpdateOperationTypeTest()
        {
            string connectionString = GetConnectionString("SULMAR-PC", "AdventureWorks", applicationName: "Santander");

            SantanderContext context = new SantanderContext(connectionString);

            IOperationTypeService operationTypeService = new EFOperationTypeService(context);

            OperationType operationType = operationTypeService.Get(1);

            operationType.Name = "Operacja 4";

            operationTypeService.Update(operationType);

        }


        private static void RemoveAccountOperationTest()
        {
            IAccountOperationService accountOperationService = GetService();

            accountOperationService.Remove(20);
        }

        private static void UpdateAccountOperationTest()
        {
            IAccountOperationService accountOperationService = GetEFService();

            AccountOperation accountOperation = accountOperationService.Get(22);

            accountOperation.OperationStatus = OperationStatus.EX;

            accountOperation.Id = 19;

            accountOperationService.Update(accountOperation);
        }

        private static IAccountOperationService GetEFService()
        {
            string connectionString = GetConnectionString("SULMAR-PC", "AdventureWorks", applicationName: "Santander");

            SantanderContext context = new SantanderContext(connectionString);
            IAccountOperationService accountOperationService = new EFAccountOperationService(context);

            return accountOperationService;

        }

        private static IAccountOperationService GetService()
        {
            string connectionString = GetConnectionString("SULMAR-PC", "AdventureWorks", applicationName: "Santander");

            SqlConnection connection = new SqlConnection(connectionString);

            IAccountOperationService accountOperationService = new DbAccountOperationService(connection);

            return accountOperationService;
        }

        private static void GetAccountOperationTest()
        {
            IAccountOperationService accountOperationService = GetService();

            AccountOperation accountOperation = accountOperationService.Get(22);

            Console.WriteLine(accountOperation.Account);

        }

        private static void GetAccountOperationsTest()
        {
            string connectionString = GetConnectionString("SULMAR-PC", "AdventureWorks", applicationName: "Santander");

            SqlConnection connection = new SqlConnection(connectionString);

            IAccountOperationService accountOperationService = new DbAccountOperationService(connection);

            AccountOperationSearchCriteria criteria = new AccountOperationSearchCriteria
            {
                Account = "12348",
                From = DateTime.Parse("2019-05-01"),
                To = DateTime.Parse("2019-12-01"),
            };

            var accountOperations = accountOperationService.Get(criteria);

            foreach (var operation in accountOperations)
            {
                // Console.WriteLine(operation.Account);
            }


        }

        private static void AddAccountOperationTest()
        {
            string connectionString = GetConnectionString("SULMAR-PC", "AdventureWorks", applicationName: "Santander");

            SqlConnection connection = new SqlConnection(connectionString);

            IAccountOperationService accountOperationService = new DbAccountOperationService(connection);


            AccountOperationFaker accountOperationFaker = new AccountOperationFaker();

            var accountOperations = accountOperationFaker.GenerateLazy(100_000);

            foreach (var accountOperation in accountOperations)
            {
                accountOperationService.Add(accountOperation);
            }

            //OperationType operationType = new OperationType
            //{
            //    Id = 1,
            //    Name = "Operacja 1"
            //};

            //AccountOperation accountOperation = new AccountOperation(operationType)
            //{
            //    Id = 10,
            //    Account = "123490200",
            //    OperationStatus = OperationStatus.OK,
            //};

            //   string connectionString = "Data Source=SULMAR-PC;Initial Catalog=AdventureWorks;Integrated Security=True;Application Name=Santander";

           
            
        }

        private static string GetConnectionString(
            string host, 
            string database, 
            bool integratedSecurity = true, 
            string userId = "", 
            string password = "", 
            string applicationName = "")
        {
            var builder = new SqlConnectionStringBuilder();
            builder.DataSource = host;
            builder.InitialCatalog = database;
            builder.PersistSecurityInfo = true;
            builder.UserID = userId;
            builder.Password = password;
            builder.MultipleActiveResultSets = true;
            builder.ApplicationName = applicationName;
            builder.IntegratedSecurity = integratedSecurity;

            return builder.ToString();
        }
    }
}
