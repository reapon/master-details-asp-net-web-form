<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="MasterDetailsTest.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script src="Scripts/jquery-3.4.1.js"></script>

    <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>

    <style>
        #imgpreview {
            border-width: 0px;
            visibility: hidden;
        }
    </style>

    <div>
  
  
        <asp:FileUpload ID="FileUpload1" runat="server" ClientIDMode="Static" onchange="showpreview(this);"/><br/>

        <asp:Button ID="Button1" runat="server" Text="Upload File" OnClick="UploadFile" /><br/>
        <asp:Image ID="imgpreview" runat="server" ClientIDMode="Static" height="200" width="200" />
        
        

        
    </div>
    
    
    <script type="text/javascript">
        
       


        function showpreview(input) {

            if (input.files && input.files[0]) {

                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#imgpreview').css('visibility', 'visible');
                    $('#imgpreview').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }

        }

       

    </script>
    
    
</asp:Content>

