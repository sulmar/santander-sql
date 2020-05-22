using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.CLRStoredProcedures
{
    public partial class StoredProcedures
    {
        [SqlMethod]
        public static void HelloWorld()
        {
            SqlContext.Pipe.Send("Hello World!\n");
        }
    }
}
