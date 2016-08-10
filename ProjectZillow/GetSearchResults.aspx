﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GetSearchResults.aspx.cs" Inherits="ProjectZillow.GetSearchResults" ValidateRequest="false" %>

<%@ Register TagName="CustomState" TagPrefix="cus" Src="~/UserControls/GetStates.ascx" %>
<%@ Register TagName="CustomCity" TagPrefix="cus" Src="~/UserControls/GetCity.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Zillow - Find a Home</title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

    <link href="../Styles/style.css" type="text/css" rel="stylesheet" />
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function GetStatesSession() {
            document.getElementById('<%=btnGetStateValue.ClientID%>').click();
        }

        function clearTextboxes() {
            //clear the text boxes
            document.getElementById('<%=txtAddress.ClientID%>').value = "";
            document.getElementById('<%=txtZip.ClientID%>').value = "";
            document.getElementById('<%=cusState.FindControl("hdnStateBox").ClientID %>').value = "";
            document.getElementById('<%=cusCity.FindControl("hdnCityBox").ClientID %>').value = "";
            document.getElementById('<%=cusState.FindControl("txtStateBox").ClientID %>').value = "";
            document.getElementById('<%=cusCity.FindControl("txtCityBox").ClientID %>').value = "";
            document.getElementById('<%=cusCity.FindControl("hdnSelectedState").ClientID %>').value = "";

            //Clear the Results and Message Fields
            document.getElementById('<%=txtResults.ClientID %>').value = "";
            document.getElementById('<%=lblMessage.ClientID %>').value = "";
        }

        function alertNoStateSelected() {
            alert("Please select a State before selecting a City");
            return false;
        }

        function ClearFields() {
            document.getElementById('<%=txtResults.ClientID %>').value = "";
            document.getElementById('<%=lblMessage.ClientID %>').value = "";
        }

        function Validate() {

            var address = document.getElementById('<%=txtAddress.ClientID%>').value;

            var hdnStateBox = document.getElementById('<%=cusState.FindControl("hdnStateBox").ClientID %>').value;
            var hdnCityBox = document.getElementById('<%=cusCity.FindControl("hdnCityBox").ClientID %>').value;
            var zipCode = document.getElementById('<%=txtZip.ClientID%>').value;
        
            if (address == "") {
                alert("Please enter the Address to search");
                document.getElementById('<%=txtAddress.ClientID%>').focus();
                return false;
            }

            if (zipCode == "" && hdnStateBox == "" && hdnCityBox == "") {
                alert("Please enter the Zip Code or State/City fields");
                document.getElementById('<%=txtZip.ClientID%>').focus();
                return false;
            }

            if (zipCode == "" && ((hdnStateBox != "" && hdnCityBox == "") || (hdnStateBox == "" && hdnCityBox != ""))) {
                alert("State and City fields are both required for search");
                document.getElementById('<%=cusState.FindControl("txtStateBox").ClientID %>').focus();
                return false;
            }
                      
         

            return true;
        }

        function checkLength()
        {
            var strZip = document.getElementById('<%=txtZip.ClientID%>').value;

            if (strZip.length > 5) {
                alert("Zip Code cannot be greater than 5 digits!");
                document.getElementById('<%=txtZip.ClientID%>').value = strZip.substring(0, 5);
                return false;
            }
        }

        function checkValue(e) {  
            if ((e.which < 48 || e.which > 57) & e.which != 8) {
                e.preventDefault();
                return false;

            }
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel runat="server" ID="updatePanelContent">
            <ContentTemplate>
                <div style="height: 20%; width: 100%;">
                    <table style="width: auto; padding: 5px; border-spacing: 5px; border-collapse: separate; margin: 0 auto; align-content: center">
                        <tr>
                            <td colspan="2" style="text-align: center">
                                <h2>Zillow - GetSearchResults API</h2>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Label ID="lblAddress" runat="server" Text="Address"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtAddress" runat="server" ToolTip="Enter Address" TabIndex="1" Width="400px" Text="" placeholder="Enter Address"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Label ID="lblZip" runat="server" Text="Zip"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtZip" runat="server" ToolTip="Enter Zip Code" TabIndex="2" Width="400px" Text="" placeholder="Enter Zip" onkeypress="checkValue(event);" onkeyup="checkLength()"></asp:TextBox>          
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center">OR
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Label ID="lblState" runat="server" Text="State"></asp:Label>
                            </td>
                            <td>
                                <cus:CustomState runat="server" ID="cusState" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Label ID="lblCity" runat="server" Text="City"></asp:Label>
                            </td>
                            <td>
                                <cus:CustomCity runat="server" ID="cusCity" />
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" style="text-align: center">
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center">
                                <asp:Button runat="server" ID="btnSubmit" OnClick="btnSubmit_Click" OnClientClick="ClearFields(); return Validate();" Text="Find a Home" TabIndex="4" />
                                &nbsp;&nbsp;&nbsp;
                       <input type="button" id="btnClearFields" onclick="clearTextboxes();" runat="server" value="Clear" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center">
                                <asp:Label runat="server" ID="lblMessage" Style="color: red; font-weight: bold" EnableViewState="false"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="height: 80%; width: 100%;">

                    <fieldset title="Zillow Results">
                        <legend>Zillow Results</legend>
                        <asp:TextBox ID="txtResults" runat="server" TextMode="MultiLine" Height="700px" Width="100%" ReadOnly="true" BorderStyle="None" Style="overflow: auto" EnableViewState="false" />
                    </fieldset>

                </div>
                <input type="button" id="btnGetStateValue" onserverclick="btnGetStateValue_Click" runat="server" style="visibility: hidden;" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>


<script type="text/javascript">

    $(document).ready(function () {
        BindState();
        BindCities();
    });

    var prm = Sys.WebForms.PageRequestManager.getInstance();

    prm.add_endRequest(function () {
        BindState();
        BindCities();
    });


</script>
