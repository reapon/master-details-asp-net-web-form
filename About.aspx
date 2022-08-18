<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="MasterDetailsTest.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

   






    <div class="container">

        <input type="hidden" name="MasterDetailsJSON" />

        <div class="form-group">
            <label>Category</label>
            <input type="text" class="form-control" placeholder="Enter Category">
        </div>

        <hr />

        <div class="row">

            <table class="table table-bordered table-striped" id="table">
                <thead>
                    <tr>
                        <td>Product Name</td>
                        <td>Price</td>
                        <td>Action</td>
                    </tr>
                </thead>

                <tbody>
                    <tr>
                        <td>


                            <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Product Name">
                        </td>

                        <td>


                            <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Price">
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
        <hr />

        <div class="row">
            <div class="col-md-2">
                <button class="btn btn-sm btn-default" id="submit-btn">Submit All</button>
            </div>
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


             $("#submit-btn").click(function (event) {

                 event.preventDefault();

                 var masterDetails = new Array();
                 var table = document.getElementById('table');
                 for (var i = 1; i < table.rows.length; i++) {
                     var row = table.rows[i];
                     var masterD = {};
                     masterD.ProductName = row.cells[0].getElementsByTagName('input')[0].value;
                     masterD.Price = row.cells[1].getElementsByTagName('input')[0].value;
                     masterDetails.push(masterD);

                 }

                 document.getElementsByName("MasterDetailsJSON")[0].value = JSON.stringify(masterDetails);
                 console.log(masterDetails);

             });


         });

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

             if (name === "" || price === "") {
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
