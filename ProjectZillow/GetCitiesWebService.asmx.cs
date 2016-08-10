using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Xml;
using System.Data;

namespace ProjectZillow
{
    /// <summary>
    /// Summary description for GetCitiesWebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]

    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class GetCitiesWebService : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        public class Cities
        {
            public string cityText { get; set; }
            public string cityValue { get; set; }
        }

        [WebMethod]
        public List<Cities> GetCities(string q,string p)
        {
            USZipCode.USZipSoapClient service = new USZipCode.USZipSoapClient("USZipSoap");
            XmlNodeList results1 = service.GetInfoByState(p.Trim()).SelectNodes("/Table");

            DataTable dt = new DataTable();
            dt.Columns.Add("CITY");

            List<Cities> Payors = new List<Cities>();

            foreach(XmlNode node in results1)
            {
                dt.Rows.Add(node["CITY"].InnerText.ToString());
            }
                      

            var results = from row in dt.AsEnumerable()
                          where row.Field<string>("city").StartsWith(q,StringComparison.CurrentCultureIgnoreCase)
                          select new Cities
                          {
                              cityText = row.Field<String>("CITY"),
                              cityValue = row.Field<String>("CITY")
                          };
            
            var list = results.GroupBy(r => r.cityText).Select(grp => grp.First()); 

            if (list.Count() > 0)
                return list.ToList();
            else
                return Enumerable.Empty<Cities>().ToList<Cities>();

        }


    }
}
