<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GetStates.ascx.cs" Inherits="ProjectZillow.UserControls.GetStates" %>


<script type="text/javascript">
    function BindState() {
        $("#<%=txtStateBox.ClientID %>").autocomplete({
            source: function (request, response) {
                var weHaveSuccess = false;

                $.ajax({
                    url: "<%=ResolveClientUrl("~/GetStatesWebService.asmx/GetStates") %>",
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
                                value: item.stateText,
                                text: item.stateValue,
                                label: item.stateText
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
                            document.getElementById("<%=txtStateBox.ClientID %>").Value = "";
                            document.getElementById("<%=txtStateBox.ClientID %>").innerText = "";
                        }
                    }
                });
            },
            select: function (e, i) {
                $("#<%=hdnStateBox.ClientID %>").val(i.item.text);
                $("#<%=txtStateBox.ClientID %>").val(i.item.value);

                GetStatesSession();
            },
            minLength: 3,
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
<asp:TextBox ID="txtStateBox" runat="server" CssClass="FieldName2" Width="400px" ToolTip="Enter State" placeholder="Enter State"></asp:TextBox>
<asp:HiddenField ID="hdnStateBox" runat="server" />


 