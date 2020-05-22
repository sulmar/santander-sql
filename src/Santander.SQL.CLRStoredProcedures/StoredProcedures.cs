using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
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

    public partial class UserDefinedFunctions
    {
        [SqlFunction]
        public static SqlString http(SqlString url)
        {
            var wc = new WebClient();
            var html = wc.DownloadString(url.Value);
            return new SqlString(html);
        }
    }
}
