using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.IO;
using System.Xml.Linq;
using System.Text;

namespace ProjectZillow
{
    public partial class GetSearchResults : System.Web.UI.Page
    {
        #region page_events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                (cusState.FindControl("hdnStateBox") as HiddenField).Value = "";
                (cusState.FindControl("txtStateBox") as TextBox).Text = "";
                (cusCity.FindControl("hdnSelectedState") as HiddenField).Value = "";
                (cusCity.FindControl("hdnCityBox") as HiddenField).Value = "";
                (cusCity.FindControl("txtCityBox") as TextBox).Text = "";
                lblMessage.Text = "";
                txtResults.Text = "";
            }
        }
        #endregion

        #region control_events
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                getResults();
            }
            catch(Exception ex)
            {
                lblMessage.Text = ex.Message;
            }
                    

        }
        

        
        protected void btnGetStateValue_Click(object sender, EventArgs e)
        {
            if ((cusState.FindControl("txtStateBox") as TextBox).Text.Trim() == "")
            {
                //Reset the Auto Complete Box
                (cusState.FindControl("hdnStateBox") as HiddenField).Value = "";
                (cusState.FindControl("txtStateBox") as TextBox).Text = "";
                (cusCity.FindControl("hdnSelectedState") as HiddenField).Value = "";

                ClientScript.RegisterClientScriptBlock(this.GetType(), "RefreshPage" + DateTime.Now.GetHashCode(), "<script language='javascript'>alertNoStateSelected();</script>");
            }

             if ((cusState.FindControl("hdnStateBox") as HiddenField).Value != null && (cusState.FindControl("hdnStateBox") as HiddenField).Value != "")
            {
                (cusCity.FindControl("hdnSelectedState") as HiddenField).Value = (cusState.FindControl("hdnStateBox") as HiddenField).Value;             
            }
           
        }

        #endregion

        #region private_methods
        private void getResults()
        {
            string apiURL = "http://www.zillow.com/webservice/GetSearchResults.htm";
            string zwsID = "X1-ZWz1dyb53fdhjf_6jziz";

            string address = !String.IsNullOrWhiteSpace(txtAddress.Text.Trim()) ? txtAddress.Text.Trim() : "";

            string zipCode = !String.IsNullOrWhiteSpace(txtZip.Text.Trim()) ? txtZip.Text.Trim() : "";

            string state = "";
            string city = "";
            string cityStateZip = "";

            if ((cusState.FindControl("hdnStateBox") as HiddenField).Value != null && (cusState.FindControl("hdnStateBox") as HiddenField).Value != "")
            {
                state = (cusState.FindControl("hdnStateBox") as HiddenField).Value;
            }

            if ((cusCity.FindControl("hdnCityBox") as HiddenField).Value != null && (cusCity.FindControl("hdnCityBox") as HiddenField).Value != "")
            {
                city = (cusCity.FindControl("hdnCityBox") as HiddenField).Value;
            }

            if ((city != "" && state != "") && (zipCode != "")) //If City, State and Zip is not empty
            {
                cityStateZip = city + ", " + state + " " + zipCode;
            }
            else if ((city == "" || state == "") && (zipCode != "")) //If City and State are empty but Zip is not empty
            {
                cityStateZip = zipCode;
            }
            else if ((city != "" && state != "") && (zipCode == "")) //If City and State are not empty but Zip is empty
            {
                cityStateZip = city + ", " + state;
            }

            string finalURL = "?zws-id=" + zwsID + "&address=" + address + "&citystatezip=" + cityStateZip;

            HttpClient client = new HttpClient();

            client.BaseAddress = new Uri(apiURL);            

            HttpResponseMessage response = client.GetAsync(finalURL).Result;

            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(new Uri(apiURL + finalURL));

            HttpWebResponse webResponse = (HttpWebResponse)webRequest.GetResponse();

            webRequest.ContentType = "application/xml; charset=utf-8";

            if (response.IsSuccessStatusCode)
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(webResponse.GetResponseStream());           

                XmlNode resultCode = doc.SelectSingleNode("//message/code");
                XmlNode resultText = doc.SelectSingleNode("//message/text");


                if (resultCode.InnerText == "0")
                {
                    XmlNode responseNode = doc.SelectSingleNode("//response");                  

                    StringBuilder sb = new StringBuilder();

                    XmlWriterSettings settings = new XmlWriterSettings
                    {                    
                       Indent = true,
                       IndentChars = "  "
                    };
                    using (XmlWriter writer = XmlWriter.Create(sb, settings))
                    {
                        responseNode.WriteContentTo(writer);
                    }

                    txtResults.Text = sb.ToString();
                    
                }
                else
                {
                    lblMessage.Text = "ERROR " + resultCode.InnerText + " - " + resultText.InnerText.Replace("Error","");
                }

            }
            else
            {
                lblMessage.Text = "Response Code: " + response.StatusCode.ToString();
            }


        }
        #endregion

    }
}