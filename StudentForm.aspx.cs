using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;


using System.Web.UI;


namespace MasterDetailsTest
{
    public partial class StudentForm : System.Web.UI.Page
    {
        public static String connection = ConfigurationManager.ConnectionStrings["MasterDetailsConnection"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGridView();
                saveButton.Visible = true;
                updateButton.Visible = false;
            }
        }


        protected void LoadGridView()
        {
            string query = @"select StudentID, ID, StudentName, FatherName, MotherName, Religion, Address, Mobile, Email, DOB,IsWaiver, Age, ImagePath from tblStudent";

            using (SqlConnection con = new SqlConnection(connection))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(query, con))
                {
                    using (DataTable dt = new DataTable())
                    {
                        sda.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            gdViewStudent.DataSource = dt;
                            gdViewStudent.DataBind();

                        }

                        else
                        {
                            gdViewStudent.DataSource = null;
                            gdViewStudent.DataBind();
                        }

                    }
                }
                con.Close();
            }

        }

        protected void saveButton_Click(object sender, EventArgs e)
        {
            string folderPath = Server.MapPath("~/Images/");

            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            if (imageFile.FileName != "")
            {
                imageFile.SaveAs(folderPath + Path.GetFileName(imageFile.FileName));

            }
            else
            {
                ShowAlert("Image Required!!");
                return;

            }


            string masterDetailsJson = Request.Form["MasterDetailsJSON"];
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(masterDetailsJson);

            if (dt.Rows.Count == 0)
            {
                ShowAlert("Please insert at least one result record!!!");
                return;
            }

            string studentId = Guid.NewGuid().ToString();
            SqlTransaction transaction = null;




            using (SqlConnection con = new SqlConnection(connection))
            {
                try
                {
                    con.Open();
                    transaction = con.BeginTransaction("MasterDetailsTransaction");
                    SqlCommand cmd =
                        new SqlCommand(
                            "Insert Into tblStudent (StudentID, ID, StudentName, FatherName, MotherName, Religion, Address, Mobile, Email, DOB,IsWaiver, Age, ImagePath) Values(@StudentID, @ID, @StudentName, @FatherName, @MotherName, @Religion, @Address, @Mobile, @Email, @DOB, @IsWaiver, @Age, @ImagePath)",
                            con, transaction);

                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    cmd.Parameters.AddWithValue("@ID", studentIdTextBox.Value);
                    cmd.Parameters.AddWithValue("@StudentName", studentNameTextBox.Value);
                    cmd.Parameters.AddWithValue("@FatherName", fatherNameTextBox.Value);
                    cmd.Parameters.AddWithValue("@MotherName", motherNameTextBox.Value);
                    cmd.Parameters.AddWithValue("@Religion", ddlReligion.SelectedValue);
                    cmd.Parameters.AddWithValue("@Address", addressTextBox.Value);
                    cmd.Parameters.AddWithValue("@Mobile", mobileTextBox.Value);
                    cmd.Parameters.AddWithValue("@Email", emailTextBox.Value);
                    cmd.Parameters.AddWithValue("@DOB", dobTextBox.Value);
                    cmd.Parameters.AddWithValue("@IsWaiver", isWaiverCheckBox.Checked);
                    cmd.Parameters.AddWithValue("@Age", ageTextBox.Value);
                    cmd.Parameters.AddWithValue("@ImagePath", imageFile.FileName);


                    cmd.ExecuteNonQuery();

                    foreach (DataRow item in dt.Rows)
                    {

                        SqlCommand cmdTwo =
                            new SqlCommand(
                                "Insert Into tblStudentResult (ExamName, Board, PassYear, Result, Remarks, StudentID) Values (@ExamName, @Board, @PassYear, @Result, @Remarks, @StudentID)",
                                con, transaction);


                        cmdTwo.Parameters.AddWithValue("@ExamName", item.ItemArray[0]);
                        cmdTwo.Parameters.AddWithValue("@Board", item.ItemArray[1]);
                        cmdTwo.Parameters.AddWithValue("@PassYear", item.ItemArray[2]);
                        cmdTwo.Parameters.AddWithValue("@Result", item.ItemArray[3]);
                        cmdTwo.Parameters.AddWithValue("@Remarks", item.ItemArray[4]);
                        cmdTwo.Parameters.AddWithValue("@StudentID", studentId);
                        cmdTwo.ExecuteNonQuery();



                    }



                    transaction.Commit();

                    con.Close();
                    ClearFormValues();
                    LoadGridView();

                    ShowAlert("Student Data Inserted Successfully!!!");

                }
                catch (Exception exception)
                {
                    if (transaction != null)
                        transaction.Rollback();
                    ShowAlert("Error in student information insertion!!!");
                }


            }

        }

        private void ClearFormValues()
        {

            studentIdTextBox.Value = String.Empty;
            studentNameTextBox.Value = String.Empty;
            fatherNameTextBox.Value = String.Empty;
            motherNameTextBox.Value = String.Empty;
            ddlReligion.SelectedValue = "0";
            addressTextBox.Value = String.Empty;
            mobileTextBox.Value = String.Empty;
            emailTextBox.Value = String.Empty;
            dobTextBox.Value = String.Empty;
            isWaiverCheckBox.Checked = false;
            ageTextBox.Value = String.Empty;
            StdIdTextBox.Value = String.Empty;
            oldImagePath.Value = String.Empty;
            imagePreview.ImageUrl = "";
        }







        private void ShowAlert(string strmsg)
        {
            string str1;
            str1 = "<script language = 'javascript' type = 'text/javascript'> alert('" + strmsg + "');</script>";
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "JS", str1);
        }

        protected void gdViewStudent_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            string studentId = e.CommandArgument.ToString();

            if (e.CommandName == "EditRow")
            {
                saveButton.Visible = false;
                updateButton.Visible = true;
                LoadEditData(studentId);

            }

            if (e.CommandName == "DeleteRow")
            {
                DeleteData(studentId);
            }
        }

        protected void DeleteData(string studentId)
        {
            using (SqlConnection con = new SqlConnection(connection))
            {
                try
                {
                    con.Open();

                    SqlCommand cmdOne = new SqlCommand("delete tblStudentResult where StudentID = @StudentID", con);
                    cmdOne.Parameters.AddWithValue("@StudentID", studentId);
                    cmdOne.ExecuteNonQuery();

                    SqlCommand cmd =
                        new SqlCommand(
                            "delete tblStudent  where StudentID = @StudentID",
                            con);

                    cmd.Parameters.AddWithValue("@StudentID", studentId);


                    cmd.ExecuteNonQuery();

                    con.Close();
                    updateButton.Visible = false;
                    saveButton.Visible = true;
                    LoadGridView();
                    ShowAlert("Done Delete");

                }
                catch (Exception exception)
                {

                    ShowAlert("Error in delete");
                }


            }
        }


        protected void LoadEditData(string studentId)
        {
            string query = @"select tblStudent.StudentID, ID, StudentName, FatherName, MotherName, Religion, Address, Mobile, Email, DOB, IsWaiver, Age, ImagePath, tblStudentResult.StudentResultID, ExamName, Board, PassYear, Result, Remarks from tblStudent join tblStudentResult on tblStudent.StudentID = tblStudentResult.StudentID where tblStudent.StudentID ='" + studentId + "'";

            DataTable table = new DataTable();
            string htmlStr = "";

            StdIdTextBox.Value = studentId;

            using (SqlConnection con = new SqlConnection(connection))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    SqlDataAdapter adap = new SqlDataAdapter(cmd);
                    adap.Fill(table);
                    SqlDataReader reader = cmd.ExecuteReader();
                    int counter = 0;
                    while (reader.Read())
                    {



                        studentIdTextBox.Value = reader["ID"].ToString();
                        studentNameTextBox.Value = reader["StudentName"].ToString();
                        fatherNameTextBox.Value = reader["FatherName"].ToString();
                        motherNameTextBox.Value = reader["MotherName"].ToString();
                        ddlReligion.SelectedValue = reader["Religion"].ToString();
                        addressTextBox.Value = reader["Address"].ToString();
                        mobileTextBox.Value = reader["Mobile"].ToString();
                        emailTextBox.Value = reader["Email"].ToString();
                        dobTextBox.Value = Convert.ToDateTime(reader["DOB"]).ToString("MM/dd/yyyy");
                        isWaiverCheckBox.Checked = Convert.ToBoolean(reader["IsWaiver"]);
                        ageTextBox.Value = reader["Age"].ToString();
                        imagePreview.ImageUrl = "/Images/" + reader["ImagePath"].ToString();
                        oldImagePath.Value = reader["ImagePath"].ToString();

                        string examName = reader["ExamName"].ToString();
                        string board = reader["Board"].ToString();
                        string passYear = reader["PassYear"].ToString();
                        string result = reader["Result"].ToString();
                        string remarks = reader["Remarks"].ToString();

                        if (counter == 0)
                        {
                            htmlStr += "<tr><td><input type = 'text'  value= " + examName + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                       "<td><input type = 'text'  value= " + board + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                       "<td><input type = 'number'  value= " + passYear + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                            "<td><input type = 'number' step='any' value= " + result + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                       "<td><input type = 'text'  value= " + remarks + " onfocusout = 'validationAlert(event)' class='form-control'/> </td></tr>"
                                ;
                        }
                        else
                        {
                            htmlStr += "<tr><td><input type = 'text'  value= " + examName + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                       "<td><input type = 'text'  value= " + board + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                       "<td><input type = 'number'  value= " + passYear + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                       "<td><input type = 'number' step='any' value= " + result + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                       "<td><input type = 'text'  value= " + remarks + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                       "<td> <div class='col-md-2'><button  id='deleteRow' class='btn btn-sm btn-danger'>Remove</button></div></td> </tr>"
                                ;
                        }

                        counter++;


                    }

                    tableBody.InnerHtml = htmlStr;



                    con.Close();

                }

            }


        }

        protected void AppendTbodyData()
        {
            string htmlStr = "";
            htmlStr += "<tr><td><input type = 'text'   onfocusout = 'validationAlert(event)' class='form-control' placeholder='Enter Exam Name'/> </td>" +
                       "<td><input type = 'text'   onfocusout = 'validationAlert(event)' class='form-control' placeholder='Enter Board'/> </td>" +
                       "<td><input type = 'number'   onfocusout = 'validationAlert(event)' class='form-control' placeholder='Pass Year'/> </td>" +
                       "<td><input type = 'number' step='any'  onfocusout = 'validationAlert(event)' class='form-control' placeholder='Result'/> </td>" +
                       "<td><input type = 'text'   onfocusout = 'validationAlert(event)' class='form-control' placeholder='Remarks'/> </td></tr>"
                ;


            tableBody.InnerHtml = htmlStr;
        }

        protected void updateButton_Click(object sender, EventArgs e)
        {
            string folderPath = Server.MapPath("~/Images/");

            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            string imageFileName = "";

            if (imageFile.FileName != "")
            {
                imageFile.SaveAs(folderPath + Path.GetFileName(imageFile.FileName));
                imageFileName = imageFile.FileName;

            }
            else
            {
                imageFileName = "";

            }


            string masterDetailsJson = Request.Form["MasterDetailsJSON"];
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(masterDetailsJson);

            if (dt.Rows.Count == 0)
            {
                ShowAlert("Please insert at least one result record!!!");
                return;
            }

            SqlTransaction transaction = null;




            using (SqlConnection con = new SqlConnection(connection))
            {
                try
                {
                    con.Open();
                    transaction = con.BeginTransaction("MasterDetailsTransaction");
                    SqlCommand cmd =
                        new SqlCommand(
                            "Update tblStudent set ID=@ID, StudentName=@StudentName, FatherName=@FatherName, MotherName=@MotherName, Religion=@Religion, Address=@Address, Mobile=@Mobile, Email=@Email, DOB=@DOB,IsWaiver=@IsWaiver, Age=@Age, ImagePath=@ImagePath where StudentID=@StudentID",
                            con, transaction);

                    cmd.Parameters.AddWithValue("@StudentID", StdIdTextBox.Value);
                    cmd.Parameters.AddWithValue("@ID", studentIdTextBox.Value);
                    cmd.Parameters.AddWithValue("@StudentName", studentNameTextBox.Value);
                    cmd.Parameters.AddWithValue("@FatherName", fatherNameTextBox.Value);
                    cmd.Parameters.AddWithValue("@MotherName", motherNameTextBox.Value);
                    cmd.Parameters.AddWithValue("@Religion", ddlReligion.SelectedValue);
                    cmd.Parameters.AddWithValue("@Address", addressTextBox.Value);
                    cmd.Parameters.AddWithValue("@Mobile", mobileTextBox.Value);
                    cmd.Parameters.AddWithValue("@Email", emailTextBox.Value);
                    cmd.Parameters.AddWithValue("@DOB", dobTextBox.Value);
                    cmd.Parameters.AddWithValue("@IsWaiver", isWaiverCheckBox.Checked);
                    cmd.Parameters.AddWithValue("@Age", ageTextBox.Value);
                    cmd.Parameters.AddWithValue("@ImagePath", imageFileName == "" ? oldImagePath.Value : imageFileName);


                    cmd.ExecuteNonQuery();

                    SqlCommand cmdOne = new SqlCommand("delete tblStudentResult where StudentID = @StudentID", con, transaction);
                    cmdOne.Parameters.AddWithValue("@StudentID", StdIdTextBox.Value);
                    cmdOne.ExecuteNonQuery();

                    foreach (DataRow item in dt.Rows)
                    {

                        SqlCommand cmdTwo =
                            new SqlCommand(
                                "Insert Into tblStudentResult (ExamName, Board, PassYear, Result, Remarks, StudentID) Values (@ExamName, @Board, @PassYear, @Result, @Remarks, @StudentID)",
                                con, transaction);


                        cmdTwo.Parameters.AddWithValue("@ExamName", item.ItemArray[0]);
                        cmdTwo.Parameters.AddWithValue("@Board", item.ItemArray[1]);
                        cmdTwo.Parameters.AddWithValue("@PassYear", item.ItemArray[2]);
                        cmdTwo.Parameters.AddWithValue("@Result", item.ItemArray[3]);
                        cmdTwo.Parameters.AddWithValue("@Remarks", item.ItemArray[4]);
                        cmdTwo.Parameters.AddWithValue("@StudentID", StdIdTextBox.Value);
                        cmdTwo.ExecuteNonQuery();



                    }



                    transaction.Commit();

                    con.Close();
                    ClearFormValues();
                    AppendTbodyData();
                    LoadGridView();

                    ShowAlert("Student Data Updated Successfully!!!");

                }
                catch (Exception exception)
                {
                    if (transaction != null)
                        transaction.Rollback();
                    ShowAlert("Error in student information update!!!");
                }


            }
        }

        protected void refreshButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentForm.aspx");
        }
    }
}