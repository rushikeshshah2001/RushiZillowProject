<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GetZip.ascx.cs" Inherits="ProjectZillow.UserControls.GetZip" %>

<script type="text/javascript">
    function BindZip() {
        $("#<%=txtZipBox.ClientID %>").autocomplete({
            source: function (request, response) {

                var weHaveSuccess = false;


                $.ajax({
                    url: "<%=ResolveClientUrl("~/GetZipWebService.asmx/GetZip") %>",
                    data: "{ 'q': '" + request.term + "'}",
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
                            document.getElementById("<%=txtZipBox.ClientID %>").Value = "";
                            document.getElementById("<%=txtZipBox.ClientID %>").innerText = "";
                        }
                    }
                });
            },
            select: function (e, i) {
                $("#<%=hdnZipBox.ClientID %>").val(i.item.text);
            },
            minLength: 4,
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
<asp:TextBox ID="txtZipBox" runat="server" CssClass="FieldName2" Width="200px" ToolTip="Enter City" placeholder="Enter City"></asp:TextBox>
<asp:HiddenField ID="hdnZipBox" runat="server" />


