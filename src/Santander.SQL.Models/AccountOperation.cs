using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.Models
{
    public class AccountOperation : BaseEntity
    {
        public string Account { get; set; }
        public DateTime OperationDate { get; set; }
        public OperationType OperationType { get; set; }

        public OperationStatus OperationStatus { get; set; }

        public AccountOperation()
        {

        }

        public AccountOperation(OperationType operationType)
        {
            OperationDate = DateTime.Now;
            OperationType = operationType;
        }
    }
}
