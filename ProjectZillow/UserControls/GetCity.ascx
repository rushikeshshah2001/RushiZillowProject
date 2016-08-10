<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GetCity.ascx.cs" Inherits="ProjectZillow.UserControls.GetCity" %>

<script type="text/javascript">
    function BindCities() {
        $("#<%=txtCityBox.ClientID %>").autocomplete({
            source: function (request, response) {

                var weHaveSuccess = false;


                $.ajax({
                    url: "<%=ResolveClientUrl("~/GetCitiesWebService.asmx/GetCities") %>",
                    data: "{ 'q' :'" + request.term + "', 'p':'" + $("#<%=hdnSelectedState.ClientID %>").val() + "'}",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        response($.map(data.d, function (item) {

                            if (item.stateText == "" && item.stateValue == "") {
                                weHaveSuccess = false;
                            }
                            else {
                                weHaveSuccess = true;
                            }

                            return {
                                value: item.cityText,
                                text: item.cityValue,
                                label: item.cityText
                            }
                        }))
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert("error handler!");
                    },

                    failure: function (response) {
                        alert(response.responseText);
                    },

                    complete: function () {
                        if (!weHaveSuccess) {
                            alert('Incorrect Search Text');
                            document.getElementById("<%=txtCityBox.ClientID %>").Value = "";
                            document.getElementById("<%=txtCityBox.ClientID %>").innerText = "";
                        }
                    }
                });
            },
            select: function (e, i) {
                $("#<%=hdnCityBox.ClientID %>").val(i.item.text);
            },
            minLength: 5,
            delay: 50
        });
        }

        ////$(function () {
        //$(document).ready(function () {
        //    BindState();
        //});

        //var prm = Sys.WebForms.PageRequestManager.getInstance();

        //prm.add_endRequest(function () {
        //    BindState();
        //});
</script>
<asp:TextBox ID="txtCityBox" runat="server" CssClass="FieldName2" Width="400px" ToolTip="Enter City" placeholder="Enter City"></asp:TextBox>
<asp:HiddenField ID="hdnCityBox" runat="server" />
<asp:HiddenField ID="hdnSelectedState" runat="server" />
