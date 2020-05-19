using Bogus;
using Santander.SQL.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.Fakers
{
    // Install-Package Bogus

    // 123490104

    public class AccountOperationFaker : Faker<AccountOperation>
    {
        public AccountOperationFaker()
        {
            IEnumerable<OperationType> operationTypes = new List<OperationType>
            {
                new OperationType { Id = 1 },
                new OperationType { Id = 2 },
                new OperationType { Id = 3 }
            };

            StrictMode(true);
            RuleFor(p => p.Id, f => f.IndexFaker + 20);
            RuleFor(p => p.Account, f => f.Random.ReplaceNumbers("1234#####"));
            RuleFor(p => p.OperationDate, f => f.Date.Past());
            RuleFor(p => p.OperationType, f => f.PickRandom(operationTypes));
            RuleFor(p => p.OperationStatus, f => f.PickRandom<OperationStatus>());
        }
    }
}
