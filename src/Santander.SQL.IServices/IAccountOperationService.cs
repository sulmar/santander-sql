using Santander.SQL.Models;
using Santander.SQL.Models.SearchCriterias;
using System.Collections.Generic;

namespace Santander.SQL.IServices
{
    public interface IAccountOperationService
    {
        void Add(AccountOperation accountOperation);

        IEnumerable<AccountOperation> Get(AccountOperationSearchCriteria searchCriteria);

        AccountOperation Get(int id);

        void Update(AccountOperation accountOperation);

        void Remove(int id);
    }
}
