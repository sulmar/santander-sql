using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.Models
{
    public class Store
    {
        public int Id { get; set; }
        public string Title { get; set; }

        public string jsonlocation { get; set; }

        [NotMapped]
        public Address Address
        {
            get
            {
                return JsonConvert.DeserializeObject<Address>(jsonlocation);
            }
            set
            {
                jsonlocation = JsonConvert.SerializeObject(value);
            }
        }
    }

    public class Address
    {
        public string Street { get; set; }
        public string PostCode { get; set; }
        public GeoLocation Geo { get; set; }
    }

    public class GeoLocation
    {
        public float Latitude { get; set; }
        public float Longitude { get; set; }
    }
}
