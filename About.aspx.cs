using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
namespace MasterDetailsTest
{
    public partial class About : Page
    {
        public static String connection = ConfigurationManager.ConnectionStrings["MasterDetailsConnection"].ToString();


        protected void Page_Load(object sender, EventArgs e)
        {

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
                                "Insert Into Product (ProductName, Price, Code, CateogoryID) Values(@ProductName, @Price, @Code, @CateogoryID)",
                                con, transaction);


                        cmdTwo.Parameters.AddWithValue("@ProductName", item.ItemArray[0]);
                        cmdTwo.Parameters.AddWithValue("@Price", item.ItemArray[1]);
                        cmdTwo.Parameters.AddWithValue("@Code", item.ItemArray[2]);
                        cmdTwo.Parameters.AddWithValue("@CateogoryID", categoryId);
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
        }


        private void ShowAlert(string strmsg)
        {
            string str1;
            str1 = "<script language = 'javascript' type = 'text/javascript'> alert('" + strmsg + "');</script>";
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "JS", str1);
        }
    }

}