using Santander.SQL.IServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Santander.SQL.Models;
using Santander.SQL.Models.SearchCriterias;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;

namespace Santander.SQL.EFServices
{

    public class EFOperationTypeService : IOperationTypeService
    {
        private readonly SantanderContext context;

        public EFOperationTypeService(SantanderContext context)
        {
            this.context = context;
        }

        public void Add(OperationType operationType)
        {
            context.OperationTypes.Add(operationType);

            IEnumerable<DbEntityEntry> entities = context.ChangeTracker.Entries();

            foreach (var entity in entities)
            {
                Console.WriteLine(entity.State);
            }
        }

        public OperationType Get(int id)
        {
           // context.Database.SqlQuery<OperationType>()

            return context.OperationTypes.Find(id);
        }

        public void Update(OperationType operationType)
        {
            // var existingOperationType = Get(operationType.Id);

            // Console.WriteLine(context.Entry(operationType).State);

            // existingOperationType.Name = operationType.Name;

            context.Entry(operationType).State = EntityState.Modified;

            context.SaveChanges();

            Console.WriteLine(context.Entry(operationType).State);
        }
    }



    public class EFAccountOperationService : IAccountOperationService
    {
        private readonly SantanderContext context;

        public EFAccountOperationService(SantanderContext context)
        {
            this.context = context;
        }

        public void Add(AccountOperation accountOperation)
        {
            context.AccountOperations.Add(accountOperation);


            var entities = context.ChangeTracker.Entries().ToList();


            foreach (var entity in entities)
            {
               // entity.
            }

            context.SaveChanges();
        }

        public IEnumerable<AccountOperation> Get(AccountOperationSearchCriteria searchCriteria)
        {
            IQueryable<AccountOperation> query = context.AccountOperations.AsNoTracking().AsQueryable();

            if (!string.IsNullOrEmpty(searchCriteria.Account))
            {
                query = query.Where(p => p.Account.StartsWith(searchCriteria.Account));
            }

            if (searchCriteria.From.HasValue)
            {
                query = query.Where(p => p.OperationDate >= searchCriteria.From);
            }

            if (searchCriteria.To.HasValue)
            {
                query = query.Where(p => p.OperationDate >= searchCriteria.To);
            }

            //var results = context.AccountOperations.AsNoTracking()
            //    .Where(p => p.Account.StartsWith(searchCriteria.Account))
            //    .Where(p => p.OperationDate >= searchCriteria.From)
            //    .Where(p => p.OperationDate <= searchCriteria.To)
            //    .ToList();

            return query.ToList();
        }

        public AccountOperation Get(int id)
        {
            return context.AccountOperations.Find(id);
        }

        public void Update(AccountOperation accountOperation)
        {
            //var existAccountOperation = context.AccountOperations.Find(accountOperation.Id);
            //existAccountOperation.OperationStatus = accountOperation.OperationStatus;

            context.Entry(accountOperation).Property(p => p.OperationStatus).IsModified = true;
            context.SaveChanges();

        }

        public void Remove(int id)
        {
            AccountOperation accountOperation = new AccountOperation { Id = id };
            context.AccountOperations.Remove(accountOperation);

            //context.AccountOperations.Attach(accountOperation);
            //context.Entry(accountOperation).State = EntityState.Deleted;

            context.SaveChanges();
        }
    }
}
