using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Data;

namespace ProjectZillow
{
    /// <summary>
    /// Summary description for GetStatesWebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]

    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]

    public class GetStatesWebService : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        public class States
        {
            public string stateText { get; set; }
            public string stateValue { get; set; }
        }

        [WebMethod]
        public List<States> GetStates(string q)
        {
            //JObject obj = JObject.Parse(File.ReadAllText("states.json")); //
            JObject obj = JObject.Parse(File.ReadAllText(HttpContext.Current.Request.MapPath("~/app_data/states.json")));
            string s = obj.ToString();

            List<States> Payors = new List<States>();

            Object jObject = JsonConvert.DeserializeObject<JObject>(s);
            DataSet dataSet = JsonConvert.DeserializeObject<DataSet>(jObject.ToString());

            DataTable dt = dataSet.Tables[0];//(DataTable)JsonConvert.DeserializeObject(s, (typeof(DataTable)));

            var results = from row in dt.AsEnumerable()
                          where row.Field<string>("stateFull").StartsWith(q, StringComparison.CurrentCultureIgnoreCase)
                          select new States
                          {
                              stateText = row.Field<String>("stateFull"),
                              stateValue = row.Field<String>("stateShort")
                          };

            var list = results.ToList();

            if (list.Count() > 0)
                return list.ToList();
            else
                return Enumerable.Empty<States>().ToList<States>();

        }
    }
}
