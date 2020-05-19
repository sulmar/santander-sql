using Santander.SQL.Models;
using Santander.SQL.Models.SearchCriterias;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.IServices
{
    public interface IAccountOperationService
    {
        void Add(AccountOperation accountOperation);

        IEnumerable<AccountOperation> Get(AccountOpeationSearchCriteria searchCriteria);
    }
}
