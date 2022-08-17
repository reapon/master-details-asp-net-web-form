<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="MasterDetailsTest.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {

            $("#add-product").click(function (event) {
                event.preventDefault();
                var newRow = $("<tr>");
                var cols = '';




                cols += `<td>
                           
                                <input type="text" class="form-control" placeholder="Enter Product Name">
                       
                            </td>

                        <td>
                            

                                <input type="text" class="form-control" placeholder="Enter Price">
                         
                        </td>

                        <td>
                    <div class="col-md-2">

                        <button class="btn btn-sm btn-danger" id="deleteRow">Remove</button>
                    </div>
                </td>`;

                newRow.append(cols);

                $("#table").append(newRow);



            });


            $("#table").on("click",
                "#deleteRow",
                function (event) {
                    event.preventDefault();
                    $(this).closest("tr").remove();
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



        })



    </script>






    <div class="container">

        <input type="hidden" name="MasterDetailsJSON"/>

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


                            <input type="text"  class="form-control" placeholder="Enter Product Name">
                        </td>

                        <td>


                            <input type="text"  class="form-control" placeholder="Enter Price">
                        </td>

                        <td>
                            <div class="col-md-2">

                                <%--<button class="btn btn-sm btn-danger" id="deleteRow" type="button">Remove</button>--%>
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
</asp:Content>
