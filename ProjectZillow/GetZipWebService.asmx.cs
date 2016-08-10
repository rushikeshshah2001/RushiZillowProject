using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Xml;

namespace ProjectZillow
{
    /// <summary>
    /// Summary description for GetZipWebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    
    [System.Web.Script.Services.ScriptService]

    public class GetZipWebService : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        public class Zip
        {
            public string zipValue { get; set; }            
        }

        [WebMethod]
        public List<Zip> GetZip(string q)
        {
            USZipCode.USZipSoapClient service = new USZipCode.USZipSoapClient("USZipSoap");
            XmlNodeList results1 = service.GetInfoByZIP(q.Trim()).SelectNodes("/Table");

            DataTable dt = new DataTable();
            dt.Columns.Add("ZIP");

            List<Zip> Payors = new List<Zip>();

            foreach (XmlNode node in results1)
            {
                dt.Rows.Add(node["ZIP"].InnerText.ToString());
            }


            var results = from row in dt.AsEnumerable()
                          where row.Field<string>("zip").StartsWith(q, StringComparison.CurrentCultureIgnoreCase)
                          select new Zip
                          {
                              zipValue = row.Field<String>("ZIP")                             
                          };

            var list = results.GroupBy(r => r.zipValue).Select(grp => grp.First());

            if (list.Count() > 0)
                return list.ToList();
            else
                return Enumerable.Empty<Zip>().ToList<Zip>();

        }
    }
}
