using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MasterDetailsTest
{
    public partial class About : Page
    {
        public static String connection = ConfigurationManager.ConnectionStrings["MasterDetailsConnection"].ToString();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGridView();
                submitBtn.Visible = true;
                updateBtn.Visible = false;
            }

        }


        protected void LoadGridView()
        {
            string query = @"select CategoryID, CategoryName, ShortName from category";

            using (SqlConnection con = new SqlConnection(connection))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(query, con))
                {
                    using (DataTable dt = new DataTable())
                    {
                        sda.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            gdViewMasterDetails.DataSource = dt;
                            gdViewMasterDetails.DataBind();
                            //Required for jQuery DataTables to work.
                            //gdViewMasterDetails.UseAccessibleHeader = true;
                            //gdViewMasterDetails.HeaderRow.TableSection = gdViewMasterDetails.TableHeader;
                        }

                        else
                        {
                            gdViewMasterDetails.DataSource = null;
                            gdViewMasterDetails.DataBind();
                        }

                    }
                }
                con.Close();
            }

        }




        protected void submitBtn_Click1(object sender, EventArgs e)
        {

            string masterDetailsJson = Request.Form["MasterDetailsJSON"];
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(masterDetailsJson);

            string categoryId = Guid.NewGuid().ToString();
            SqlTransaction transaction = null;




            using (SqlConnection con = new SqlConnection(connection))
            {
                try
                {
                    con.Open();
                    transaction = con.BeginTransaction("MasterDetailsTransaction");
                    SqlCommand cmd =
                        new SqlCommand(
                            "Insert Into Category (CategoryID, CategoryName, ShortName) Values(@CategoryID, @CategoryName, @ShortName)",
                            con, transaction);

                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName.Value.Trim());
                    cmd.Parameters.AddWithValue("@ShortName", categoryShortName.Value.Trim());

                    cmd.ExecuteNonQuery();

                    foreach (DataRow item in dt.Rows)
                    {

                        SqlCommand cmdTwo =
                            new SqlCommand(
                                "Insert Into Product (ProductName, Price, Code, CategoryID) Values(@ProductName, @Price, @Code, @CategoryID)",
                                con, transaction);


                        cmdTwo.Parameters.AddWithValue("@ProductName", item.ItemArray[0]);
                        cmdTwo.Parameters.AddWithValue("@Price", item.ItemArray[1]);
                        cmdTwo.Parameters.AddWithValue("@Code", item.ItemArray[2]);
                        cmdTwo.Parameters.AddWithValue("@CategoryID", categoryId);
                        cmdTwo.ExecuteNonQuery();



                    }




                    transaction.Commit();

                    con.Close();
                    ClearFormValues();
                    ShowAlert("Done Insert");

                }
                catch (Exception exception)
                {
                    if (transaction != null)
                        transaction.Rollback();
                    ShowAlert("Error in Insertion");
                }


            }






        }

        private void ClearFormValues()
        {
            categoryName.Value = "";
            categoryShortName.Value = "";
            categoryIdtxtBox.Value = "";
        }


        private void ShowAlert(string strmsg)
        {
            string str1;
            str1 = "<script language = 'javascript' type = 'text/javascript'> alert('" + strmsg + "');</script>";
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "JS", str1);
        }



        protected void gdViewMasterDetails_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string categoryId = e.CommandArgument.ToString();

            if (e.CommandName == "EditRow")
            {
                submitBtn.Visible = false;
                updateBtn.Visible = true;
                LoadEditData(categoryId);

            }

            if (e.CommandName == "DeleteRow")
            {
                DeleteData(categoryId);
            }


        }

        protected void DeleteData(string categoryId)
        {
            using (SqlConnection con = new SqlConnection(connection))
            {
                try
                {
                    con.Open();

                    SqlCommand cmdOne = new SqlCommand("delete Product where CategoryID = @CategoryID", con);
                    cmdOne.Parameters.AddWithValue("@CategoryID", categoryId);
                    cmdOne.ExecuteNonQuery();

                    SqlCommand cmd =
                        new SqlCommand(
                            "delete Category where CategoryID = @CategoryID",
                            con);

                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);


                    cmd.ExecuteNonQuery();

                    con.Close();
                    updateBtn.Visible = false;
                    submitBtn.Visible = true;
                    LoadGridView();
                    ShowAlert("Done Delete");

                }
                catch (Exception exception)
                {

                    ShowAlert("Error in delete");
                }


            }
        }

        protected void LoadEditData(string categoryId)
        {
            string query = @"select Category.CategoryID, CategoryName, ShortName, ProductID, ProductName, Price, Code  from Category join Product on Category.CategoryID = Product.CategoryID where Category.CategoryID='" + categoryId + "'";

            DataTable table = new DataTable();
            string htmlStr = "";

            categoryIdtxtBox.Value = categoryId;

            using (SqlConnection con = new SqlConnection(connection))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    SqlDataAdapter adap = new SqlDataAdapter(cmd);
                    adap.Fill(table);
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {

                        categoryName.Value = reader["CategoryName"].ToString();
                        categoryShortName.Value = reader["ShortName"].ToString();

                        string productName = reader["ProductName"].ToString();
                        string price = reader["Price"].ToString();
                        string code = reader["Code"].ToString();

                        htmlStr += "<tr><td><input type = 'text'  value= " + productName + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                   "<td><input type = 'text'  value= " + price + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                   "<td><input type = 'text'  value= " + code + " onfocusout = 'validationAlert(event)' class='form-control'/> </td>" +
                                   "<td> <div class='col-md-2'><button  id='deleteRow' class='btn btn-sm btn-danger'>Remove</button></div></td> </tr>"
                                   ;
                    }

                    tableBody.InnerHtml = htmlStr;



                    con.Close();

                }

            }


        }

        protected void updateBtn_Click(object sender, EventArgs e)
        {
            string masterDetailsJson = Request.Form["MasterDetailsJSON"];
            DataTable dt = JsonConvert.DeserializeObject<DataTable>(masterDetailsJson);

            string categoryId = categoryIdtxtBox.Value;
            SqlTransaction transaction = null;




            using (SqlConnection con = new SqlConnection(connection))
            {
                try
                {
                    con.Open();
                    transaction = con.BeginTransaction("MasterDetailsTransaction");
                    SqlCommand cmd =
                        new SqlCommand(
                            "update Category set CategoryName= @CategoryName, ShortName = @ShortName where CategoryID = @CategoryID",
                            con, transaction);

                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    cmd.Parameters.AddWithValue("@CategoryName", categoryName.Value.Trim());
                    cmd.Parameters.AddWithValue("@ShortName", categoryShortName.Value.Trim());

                    cmd.ExecuteNonQuery();

                    SqlCommand cmdOne = new SqlCommand("delete Product where CategoryID = @CategoryID", con, transaction);
                    cmdOne.Parameters.AddWithValue("@CategoryID", categoryId);
                    cmdOne.ExecuteNonQuery();

                    foreach (DataRow item in dt.Rows)
                    {

                        SqlCommand cmdTwo =
                            new SqlCommand(
                                "Insert Into Product (ProductName, Price, Code, CategoryID) Values(@ProductName, @Price, @Code, @CategoryID)",
                                con, transaction);


                        cmdTwo.Parameters.AddWithValue("@ProductName", item.ItemArray[0]);
                        cmdTwo.Parameters.AddWithValue("@Price", item.ItemArray[1]);
                        cmdTwo.Parameters.AddWithValue("@Code", item.ItemArray[2]);
                        cmdTwo.Parameters.AddWithValue("@CategoryID", categoryId);
                        cmdTwo.ExecuteNonQuery();



                    }




                    transaction.Commit();

                    con.Close();
                    ClearFormValues();
                    updateBtn.Visible = false;
                    submitBtn.Visible = true;
                    AppendTbodyData();
                    LoadGridView();
                    ShowAlert("Done Update");

                }
                catch (Exception exception)
                {
                    if (transaction != null)
                        transaction.Rollback();
                    ShowAlert("Error in update");
                }


            }
        }


        protected void AppendTbodyData()
        {
            string htmlStr = "";
            htmlStr += "<tr><td><input type = 'text'   onfocusout = 'validationAlert(event)' class='form-control' placeholder='Enter Product Name'/> </td>" +
                       "<td><input type = 'text'   onfocusout = 'validationAlert(event)' class='form-control' placeholder='Enter Price'/> </td>" +
                       "<td><input type = 'text'   onfocusout = 'validationAlert(event)' class='form-control' placeholder='Enter Code'/> </td> </tr>"
                ;


            tableBody.InnerHtml = htmlStr;
        }

        protected void cancelBtn_Click(object sender, EventArgs e)
        {
            ClearFormValues();
            AppendTbodyData();
            LoadGridView();
        }
    }

}