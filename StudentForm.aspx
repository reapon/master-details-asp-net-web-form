<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentForm.aspx.cs" Inherits="MasterDetailsTest.StudentForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">

<script src="Scripts/jquery-3.4.1.js"></script>

<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>

    <div class="container" style="margin: 20px auto">
        <input type="hidden" id="masterDeailsJson" clientidmode="Static" name="MasterDetailsJSON" />
    <input type="hidden"  id="oldImagePath" runat="server" clientidmode="Static" />
    <input type="hidden"  id="StdIdTextBox" runat="server" clientidmode="Static" />
        <div class="row">
            <div class="col-md-4">
                <div class="row">
                    <div class="form-group">
                        <label>Student ID <span class="text-danger">*</span> </label>
                        <input type="text" class="form-control" id="studentIdTextBox" runat="server" clientidmode="Static" placeholder="Student ID" />
                        <div>
                            <asp:RequiredFieldValidator ID="studentIdTextBoxRequiredFieldValidator" runat="server" ErrorMessage="* Please Enter Student ID" ControlToValidate="studentIdTextBox" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Student Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="studentNameTextBox" runat="server" clientidmode="Static" placeholder="Student Name" />
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="* Please Enter Student Name" ControlToValidate="studentNameTextBox" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Father Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="fatherNameTextBox" runat="server" clientidmode="Static" placeholder="Father Name" />
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="* Please Enter Father Name" ControlToValidate="fatherNameTextBox" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Mother Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="motherNameTextBox" runat="server" clientidmode="Static" placeholder="Mother Name" />
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="* Please Enter Mother Name" ControlToValidate="motherNameTextBox" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="row">
                    <div class="form-group">
                        <label>Religion <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlReligion" runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Please Select Religion</asp:ListItem>
                            <asp:ListItem Value="Muslim">Muslim </asp:ListItem>
                            <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                            <asp:ListItem Value="Christian">Christian</asp:ListItem>
                            <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                        </asp:DropDownList>
                        <div>
                            <asp:RequiredFieldValidator ID="ddlReligionRequiredFieldValidator" runat="server" ErrorMessage="* Please Select Religion " InitialValue="0" ControlToValidate="ddlReligion" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>


                        </div>
                    </div>
                </div>



                <div class="row">
                    <div class="form-group">
                        <label>Date Of Birth <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="dobTextBox" runat="server" clientidmode="Static" onchange="getAge(this)" placeholder="Date of Birth" />
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="* Please Enter Date of Birth" ControlToValidate="dobTextBox" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Age <span class="text-danger">*</span></label>
                        <input type="text" readonly class="form-control" id="ageTextBox" runat="server" clientidmode="Static" placeholder="Age" />

                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Mobile <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="mobileTextBox" runat="server" clientidmode="Static" placeholder="Mobile Number" />
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="* Please Enter Mobile Number" ControlToValidate="mobileTextBox" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="row">
                    <div class="form-group">
                        <label>Image <span class="text-danger">*</span></label>
                        <asp:FileUpload ID="imageFile" runat="server" ClientIDMode="Static" onchange="showImagePreview(this);" /><br />

                        <asp:Image ID="imagePreview" runat="server" ClientIDMode="Static" Height="200" Width="200" />
                    </div>
                </div>
            </div>
        </div>

        <div class="row">


            <div class="col-md-4">
                <div class="row">
                    <div class="form-group">
                        <label>Address <span class="text-danger">*</span></label>

                        <textarea class="form-control" runat="server" id="addressTextBox" placeholder="Address" rows="1"></textarea>
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="* Please Enter Address" ControlToValidate="addressTextBox" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                        </div>
                    </div>
                </div>

            </div>


            <div class="col-md-4">
                <div class="row">
                    <div class="form-group">
                        <label>Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="emailTextBox" runat="server" clientidmode="Static" placeholder="Email Address" visible="True" />
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="* Please Enter Email Address" ControlToValidate="emailTextBox" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                            <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="emailTextBox" ErrorMessage="Invalid Email Format" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>

                        </div>
                    </div>
                </div>

            </div>

            <div class="col-md-4" style="margin-top: 20px">
                <div class="row">
                    <div class="form-check">
                        <div>
                          <%--  <label class="form-check-label" style="margin-left: 10px;">Is Waiver</label>

                            <input type="checkbox" class="form-check-input" id="isWaiverCheckBox">--%>
                            
                            <label class="form-check-label" >
                                <input type="checkbox" class="form-check-input" id="isWaiverCheckBox" runat="server" style="margin-top: -1px; "/>
                                <span style="margin-left: 10px;">
                                    Is Waiver
                                </span>
                                
                            </label>
                        </div>

                    </div>

                </div>


            </div>

        </div>




        <br />

        <div class="row">
            <table class="table table-bordered table-striped" id="table">
                <thead>
                    <tr>
                        <td>Exam Name</td>
                        <td>Board</td>
                        <td>Pass Year</td>
                        <td>Result</td>
                        <td>Remarks</td>
                        <td>Action</td>
                    </tr>
                </thead>

                <tbody id="tableBody" runat="server">
                    <tr>
                        <td>


                            <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Exam Name">
                        </td>

                        <td>


                            <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Board">
                        </td>
                        <td>


                            <input type="number" onfocusout="validationAlert(event)" class="form-control" placeholder="Pass Year">
                        </td>
                        <td>


                            <input type="number" step="any" onfocusout="validationAlert(event)" class="form-control" placeholder="Result">
                        </td>

                        <td>


                            <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Remarks">
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
            <div class="col-md-12">
                <div class="row">
                    <button class="btn btn-sm btn-success" id="add-result">Add Result</button>
                    <hr />

                </div>
            </div>
        </div>

        <div class="row" style="margin-top: 10px;">
            <div class="col-md-12">
                <div class="row">
                    <asp:Button ID="saveButton" runat="server" Text="Save" OnClientClick="submitClick()" CssClass="btn btn-success btn-sm" ClientIDMode="Static" OnClick="saveButton_Click" />


                    <asp:Button ID="updateButton" runat="server" Text="Update" OnClientClick="submitClick()" CssClass="btn btn-warning btn-sm" ClientIDMode="Static" OnClick="updateButton_Click" />

                    <asp:Button ID="refreshButton" runat="server" CausesValidation="False" Text="Refresh" CssClass="btn btn-info btn-sm" ClientIDMode="Static" OnClick="refreshButton_Click" />


                </div>


            </div>
        </div>
    
        <br />
    


    <div class="row">
        <div class="col-md-12">
            <div class="row">

       
        <asp:GridView ID="gdViewStudent"  AutoGenerateColumns="False"  runat="server" ClientIDMode="Static" CssClass="table table-bordered" OnRowCommand="gdViewStudent_RowCommand"   >
                
                
            <Columns>

                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="lbEdit" CommandArgument='<%# Eval("StudentID") %>' CausesValidation="False" CommandName="EditRow" CssClass="btn btn-sm btn-warning"  runat="server">Edit</asp:LinkButton>

                        <asp:LinkButton ID="lbDelete" CommandArgument='<%# Eval("StudentID") %>' CausesValidation="False" CommandName="DeleteRow" CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Are you sure?')" runat="server">Delete</asp:LinkButton>
                    </ItemTemplate>
                 
                </asp:TemplateField>
                      
                       
                <asp:BoundField DataField="StudentName" HeaderText="Std. Name"  />
                <asp:BoundField DataField="FatherName" HeaderText="Father Name"/>
                <asp:BoundField DataField="MotherName" HeaderText="Mother Name"/>
                <asp:BoundField DataField="Age" HeaderText="Age"/>
                <asp:BoundField DataField="Email" HeaderText="Email"/>
                <asp:BoundField DataField="Mobile" HeaderText="Mobile"/>
                <asp:TemplateField HeaderText="Image">
                <ItemTemplate>
                    <asp:Image  runat="server" Height="50px" Width="50px" ImageUrl='<%# Eval("ImageShow") %>' />
                </ItemTemplate>
                </asp:TemplateField>


            </Columns>
                
                
                
                

        </asp:GridView>
                
            </div>
            
        </div>
          
    </div>
    </div>


    <script type="text/javascript">
      

        $(document).ready(function () {
            $("#add-result").click(function (event) {
                event.preventDefault();
                var newRow = $("<tr>");
                var cols = '';


                cols += `<td>


                        <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Exam Name">
                    </td>

                    <td>


                        <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Enter Board">
                    </td>
                    <td>


                        <input type="number" onfocusout="validationAlert(event)" class="form-control" placeholder="Pass Year">
                    </td>
                    <td>


                        <input type="number" step="any" onfocusout="validationAlert(event)" class="form-control" placeholder="Result">
                    </td>

                    <td>


                        <input type="text" onfocusout="validationAlert(event)" class="form-control" placeholder="Remarks">
                    </td>
<td>
                    <div class="col-md-2">

                        <button class="btn btn-sm btn-danger" id="deleteRow">Remove</button>
                    </div>
                </td>`;

                newRow.append(cols);

                $("#table").append(newRow);

                if (disableAddButton()) {
                    document.getElementById("add-result")?.removeAttribute("disabled");
                } else {
                    document.getElementById("add-result")?.setAttribute("disabled", "true");
                }


            });


            $("#table").on("click",
                "#deleteRow",
                function (event) {
                    event.preventDefault();
                    $(this).closest("tr").remove();
                    if (disableAddButton()) {
                        document.getElementById("add-result")?.removeAttribute("disabled");
                    } else {
                        document.getElementById("add-result")?.setAttribute("disabled", "true");
                    }

                });
        });


        function submitClick() {
            var masterDetails = new Array();
            var table = document.getElementById('table');
            for (var i = 1; i < table.rows.length; i++) {
                var row = table.rows[i];
                var masterD = {};
                masterD.ExamName = row.cells[0].getElementsByTagName('input')[0].value;
                masterD.Board = row.cells[1].getElementsByTagName('input')[0].value;
                masterD.PassYear = row.cells[2].getElementsByTagName('input')[0].value;
                masterD.Result = row.cells[3].getElementsByTagName('input')[0].value;
                masterD.Remarks = row.cells[4].getElementsByTagName('input')[0].value;
                if (masterD.ExamName && masterD.Board && masterD.PassYear && masterD.Result && masterD.Remarks) {
                    masterDetails.push(masterD);

                }

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
                document.getElementById("add-result")?.removeAttribute("disabled");
            } else {
                document.getElementById("add-result")?.setAttribute("disabled", "true");
            }



            if (event.target.value === "") {
                event.target.classList.add("alert-danger");
                event.target.style.border = "1px solid red";
            }

        }

        function disableAddButton() {
            var row = table.rows[table.rows.length - 1];

            var exam = row.cells[0].getElementsByTagName('input')[0].value;
            var board = row.cells[1].getElementsByTagName('input')[0].value;
            var passYear = row.cells[2].getElementsByTagName('input')[0].value;
            var result = row.cells[3].getElementsByTagName('input')[0].value;
            var remarks = row.cells[4].getElementsByTagName('input')[0].value;


            if (exam === "" || board === "" || passYear === "" || result === "" || remarks === "") {
                return false;
            } else {
                return true;
            }



        }


        if (!disableAddButton()) {
            document.getElementById("add-result")?.setAttribute("disabled", "true");
        }


        function getAge(birthDate) {


            var dateString = birthDate.value;
            var now = new Date();
            var today = new Date(now.getYear(), now.getMonth(), now.getDate());

            var yearNow = now.getYear();
            var monthNow = now.getMonth();
            var dateNow = now.getDate();

            var dob = new Date(dateString.substring(6, 10),
                dateString.substring(0, 2) - 1,
                dateString.substring(3, 5)
            );

            var yearDob = dob.getYear();
            var monthDob = dob.getMonth();
            var dateDob = dob.getDate();
            var age = {};
            var ageString = "";
            var yearString = "";
            var monthString = "";
            var dayString = "";


            var yearAge = yearNow - yearDob;

            if (monthNow >= monthDob)
                var monthAge = monthNow - monthDob;
            else {
                yearAge--;
                var monthAge = 12 + monthNow - monthDob;
            }

            if (dateNow >= dateDob)
                var dateAge = dateNow - dateDob;
            else {
                monthAge--;
                var dateAge = 31 + dateNow - dateDob;

                if (monthAge < 0) {
                    monthAge = 11;
                    yearAge--;
                }
            }

            age = {
                years: yearAge,
                months: monthAge,
                days: dateAge
            };

            if (age.years > 1) yearString = " years";
            else yearString = " year";
            if (age.months > 1) monthString = " months";
            else monthString = " month";
            if (age.days > 1) dayString = " days";
            else dayString = " day";


            if ((age.years > 0) && (age.months > 0) && (age.days > 0))
                ageString = age.years + yearString + ", " + age.months + monthString + ", and " + age.days + dayString + " old.";
            else if ((age.years === 0) && (age.months === 0) && (age.days > 0))
                ageString = "Only " + age.days + dayString + " old!";
            else if ((age.years > 0) && (age.months === 0) && (age.days === 0))
                ageString = age.years + yearString + " old.";
            else if ((age.years > 0) && (age.months > 0) && (age.days === 0))
                ageString = age.years + yearString + " and " + age.months + monthString + " old.";
            else if ((age.years === 0) && (age.months > 0) && (age.days > 0))
                ageString = age.months + monthString + " and " + age.days + dayString + " old.";
            else if ((age.years > 0) && (age.months === 0) && (age.days > 0))
                ageString = age.years + yearString + " and " + age.days + dayString + " old.";
            else if ((age.years === 0) && (age.months > 0) && (age.days === 0))
                ageString = age.months + monthString + " old.";
            else ageString = "Oops! Could not calculate age!";

            document.getElementById("ageTextBox").value = ageString;
            //return ageString;
        }


        function showImagePreview(input) {

            if (input.files && input.files[0]) {

                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#imagePreview').css('visibility', 'visible');
                    $('#imagePreview').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }

        }





    </script>


    <script type="text/javascript">
        $(document).ready(function () {

            $("#dobTextBox").datepicker({
                changeMonth: true,
                changeYear: true,
                yearRange: "-200:+0"
            });



        });


        //On UpdatePanel Refresh
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function (sender, e) {
                if (sender._postBackSettings.panelsToUpdate != null) {
                    $("#dobTextBox").datepicker({
                        changeMonth: true,
                        changeYear: true,
                        yearRange: "-20:+0"
                    });




                }
            });
        };

    </script>

</asp:Content>
