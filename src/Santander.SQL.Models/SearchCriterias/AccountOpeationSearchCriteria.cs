using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.Models.SearchCriterias
{
    public class AccountOpeationSearchCriteria : Base
    {
        public DateTime From { get; set; }
        public DateTime To { get; set; }
        public string Account { get; set; }
        public OperationStatus? OperationStatus { get; set; }
    }
}
