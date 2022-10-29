<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="MasterDetailsTest.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

   






    <div class="container" style="margin:20px auto">

        <input type="hidden" id="masterDeailsJson"  clientidmode="Static" name="MasterDetailsJSON" />
        <div class="row">
            <input type="hidden"  id="categoryIdtxtBox" runat="server" clientidmode="Static" />

            <div class="col-md-4">
                <div class="form-group">
                    <label>Category</label>
                    <input type="text" class="form-control" id="categoryName" runat="server" clientidmode="Static"  placeholder="Category Name"/>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="form-group">
                    <label>Short Name</label>
                    <input type="text" class="form-control" id="categoryShortName" runat="server" clientidmode="Static"  placeholder="Category Short Name"/>
                </div>
            </div>
        </div>
       
        
    

        <hr />

        <div class="row">

            <table class="table table-bordered table-striped" id="table">
                <thead>
                    <tr>
                        <td>Product Name</td>
                        <td>Price</td>
                        <td>Code</td>
                        <td>Action</td>
                    </tr>
                </thead>

                <tbody id="tableBody" runat="server" >
                    <tr>
                        <td>


                            <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Product Name">
                        </td>

                        <td>


                            <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Price">
                        </td>
                        <td>


                            <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Code">
                        </td>

                        <td>
                            <div class="col-md-2">
                            </div>
                        </td>

                    </tr>
                </tbody>

            </table>










        </div>

        <div class="row">
            <div class="col-md-2">
                <button class="btn btn-sm btn-success" id="add-product">Add Product</button>
            </div>
        </div>

        <hr />

        <div class="row">
            <div class="col-md-2">
                <asp:Button Text="Submit All" runat="server" CssClass="btn btn-sm btn-default"   id="submitBtn" OnClientClick="submitClick()" clientidmode="Static" OnClick="submitBtn_Click1"  />
                
                <asp:Button Text="Update" runat="server" CssClass="btn btn-sm btn-info"   id="updateBtn" OnClientClick="submitClick()" clientidmode="Static" OnClick="updateBtn_Click"   />

                <asp:Button Text="Cancel" runat="server" CssClass="btn btn-sm btn-warning"   id="cancelBtn" clientidmode="Static" OnClick="cancelBtn_Click"  />
                
            </div>
        </div>
        
        <hr />
        
        <br />

        
        <div class="row">
            <asp:GridView ID="gdViewMasterDetails"  AutoGenerateColumns="False"  runat="server" ClientIDMode="Static" CssClass="table table-bordered"  OnRowCommand="gdViewMasterDetails_RowCommand" >
                
                
                   <Columns>

                       <asp:TemplateField>
                        <ItemTemplate>
                           <asp:LinkButton ID="lbEdit" CommandArgument='<%# Eval("CategoryID") %>' CommandName="EditRow" CssClass="btn btn-sm btn-warning"  runat="server">Edit</asp:LinkButton>

                            <asp:LinkButton ID="lbDelete" CommandArgument='<%# Eval("CategoryID") %>' CommandName="DeleteRow" CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Are you sure?')" runat="server">Delete</asp:LinkButton>
                        </ItemTemplate>
                 
                        </asp:TemplateField>
                      
                       
                       <asp:BoundField DataField="CategoryName" HeaderText="Category Name"  />
                       <asp:BoundField DataField="ShortName" HeaderText="Short Name" 
                            />
                     


                   </Columns>
                
                
                
                

            </asp:GridView>
          
        </div>


    </div>
    
    
    
    
     <script type="text/javascript">
         $(document).ready(function () {

             $("#add-product").click(function (event) {
                 event.preventDefault();
                 var newRow = $("<tr>");
                 var cols = '';


                 cols += `<td>                           
                                <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Product Name">                       
                            </td>
                        <td>                            
                                <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Price">                         
                        </td>

 <td>
                                <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Code">
                        </td>

                        <td>
                    <div class="col-md-2">

                        <button class="btn btn-sm btn-danger" id="deleteRow">Remove</button>
                    </div>
                </td>`;

                 newRow.append(cols);

                 $("#table").append(newRow);

                 if (disableAddButton()) {
                     document.getElementById("add-product").removeAttribute("disabled");
                 } else {
                     document.getElementById("add-product").setAttribute("disabled", "true");
                 }



             });


             $("#table").on("click",
                 "#deleteRow",
                 function (event) {
                     event.preventDefault();
                     $(this).closest("tr").remove();
                     if (disableAddButton()) {
                         document.getElementById("add-product").removeAttribute("disabled");
                     } else {
                         document.getElementById("add-product").setAttribute("disabled", "true");
                     }

                 });


            


         });

         function submitClick() {
             var masterDetails = new Array();
             var table = document.getElementById('table');
             for (var i = 1; i < table.rows.length; i++) {
                 var row = table.rows[i];
                 var masterD = {};
                 masterD.ProductName = row.cells[0].getElementsByTagName('input')[0].value;
                 masterD.Price = row.cells[1].getElementsByTagName('input')[0].value;
                 masterD.Code = row.cells[2].getElementsByTagName('input')[0].value;
                 masterDetails.push(masterD);

             }

             console.log(masterDetails);


             document.getElementsByName("MasterDetailsJSON")[0].value = JSON.stringify(masterDetails);
             console.log(masterDetails);
         }

         function validationAlert(event) {
             event.target.addEventListener("keyup", function () {


                 event.target.classList.remove("alert-danger");
                 event.target.style.border = "";


             });

             if (disableAddButton()) {
                 document.getElementById("add-product").removeAttribute("disabled");
             } else {
                 document.getElementById("add-product").setAttribute("disabled", "true");
             }

            

             if (event.target.value === "") {
                 event.target.classList.add("alert-danger");
                 event.target.style.border = "1px solid red";
             }

         }

         function disableAddButton() {
             var row = table.rows[table.rows.length - 1];

             var name = row.cells[0].getElementsByTagName('input')[0].value;
             var price = row.cells[1].getElementsByTagName('input')[0].value;
             var code = row.cells[2].getElementsByTagName('input')[0].value;

             if (name === "" || price === "" || code === "") {
                 return false;
             } else {
                 return true;
             }



         }


         if (!disableAddButton()) {
             document.getElementById("add-product").setAttribute("disabled", "true");
         }




         


     </script>
</asp:Content>
