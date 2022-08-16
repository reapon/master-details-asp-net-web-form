<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="MasterDetailsTest.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {

            $("#add-product").click(function (event) {
                event.preventDefault();
                let newRow = $("<tr>");
                let cols = '';

                console.log("aaa");


                cols += `<td>
                            <div class="col-md-6">
                                <input type="text" class="form-control" placeholder="Enter Product Name">
                            </div>
                            </td>

                        <td>
                            <div class="col-md-4">

                                <input type="text" class="form-control" placeholder="Enter Price">
                            </div>
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


            $("#submit-btn").click(function(event) {

                event.preventDefault();

                let myTable = document.getElementById('table');

                for (let row of myTable.rows) {
                    for (let cell of row.cells) {
                        console.log(cell.innerText);
                    }
                }

            });


        })



    </script>






    <div class="container">



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
                            <div class="col-md-6">

                                <input type="text" class="form-control" placeholder="Enter Product Name">
                            </div>
                        </td>

                        <td>
                            <div class="col-md-4">

                                <input type="text" class="form-control" placeholder="Enter Price">
                            </div>
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
