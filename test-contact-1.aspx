<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net.Mail" %>

    

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
<title>Enquiry Form</title>   
     
    <style type="text/css">
        #form1 {
            height: 167px;
        }
    </style>


        <script language="C#" runat="server">




            // protected means access is limited to the containing class or types derived from the containing class.
            // void is the return type of the method and means it doesn't return anything

            protected void SendMail()

            {
                // Examples
                // https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-using-smtp-net.html
                // https://stackoverflow.com/questions/30323183/contact-us-form-asp-net-mvc

                // Not needed, from an example showing how to give credentials
                // String SMTP_USERNAME = "smtp_username";
                // String SMTP_PASSWORD = "smtp_password";
                // String HOST = "email-smtp.us-west-2.amazonaws.com";

                // Configure your from e-mail
                String FROM = "YourEmail@YourSiteEmail.com";

                // Configure your from name
                String FROMNAME = "Your From Name Here";

                // Configure to e-mail, where you want to receive the e-mail from the contact form
                String TO = "YourEmail@YourToEmail.com";

                // The subject line of the email
                String SUBJECT = "Enquiry from C# Contact Form";

                // The body of the email
                String BODY = Enquiry.Text + "\n\n" +
                              "From: " + Name.Text + "\n\n" +
                              "E-mail: " + Email.Text;
                    
                MailMessage mail = new MailMessage();

                mail.From = new MailAddress(FROM, FROMNAME);

                mail.To.Add(new MailAddress(TO));

                mail.Subject = SUBJECT;

                mail.Body = BODY;

                // Configure your mailserver here
                SmtpClient SmtpServer = new SmtpClient("mail.yourdomain.com");
                SmtpServer.Send(mail);


                // Hide form fields
                FormEnquiry.Visible = false;

                lblMyTestLabel.Text = "Message Sent.";


            // End SendMail()    
            }





            protected void SubmitBtn_Click(object sender, EventArgs e) {

                SendMail();

            }





            // https://lonewolfonline.net/validate-email-addresses/#
            public bool IsEmailValid(string emailaddress)
            {
                try
                {
                    MailAddress m = new MailAddress(emailaddress);
                    return true;
                }

                catch (FormatException)
                {
                    return false;
                }
            }






            // https://docs.microsoft.com/en-us/dotnet/api/system.web.ui.webcontrols.servervalidateeventargs?view=netframework-4.8
            // Also based on https://lonewolfonline.net/validate-email-addresses/# but slightly adapted to use args
            // ServerValidateEventArgs Class provides data for the ServerValidate event of the CustomValidator control
            // The Value property of the ServerValidateEventArgs Class is used to determine the value to validate, the IsValid property is used to store the results of the validation
            // Content from the field is used to attempt to create an e-mail, to see whether content was a valid e-mail
            void ServerValidation(object source, ServerValidateEventArgs args)
            {

                try
                {

                    // Change this to check the e-mail address
                    String MyContent = args.Value;
                    // Enquiry.Text = MyContent; // Can change enquiry msg
                    MailAddress m = new MailAddress(MyContent);
                    args.IsValid = true;
                    //return true;

                }

                catch (FormatException)
                {

                    args.IsValid = false;
                    //return false;

                }

            }


        </script>


</head>

<body>

    
        <asp:Label ID="lblMyTestLabel" runat="server" Text="Please give your enquiry below."></asp:Label>


        <br /><br />


    <form id="FormEnquiry" runat="server"> 

        
        
        
        
        
        
        
        
        
        Enquiry<font color="#FF0000">*</font>:<br />   
        <asp:TextBox ID="Enquiry" runat="server" TextMode="MultiLine" Height="174px" Width="430px"></asp:TextBox>
        
        <asp:RequiredFieldValidator ID="ReqEnquiry"
        ControlToValidate="Enquiry" 
        ErrorMessage="Please state your enquiry."
        Display="Dynamic"
   		runat="server"
		ForeColor="Red">
        </asp:RequiredFieldValidator>  
         
        <br />
        
        
        
        
        
        
        

        Name<font color="#FF0000">*</font>:<br />
        <asp:TextBox ID="Name" runat="server" MaxLength="70" Columns="70"></asp:TextBox>
        
        <asp:RequiredFieldValidator ID="ReqName"
        ControlToValidate="Name" 
        ErrorMessage="Name required."
        Display="Dynamic"
   		runat="server"
		ForeColor="Red">
        </asp:RequiredFieldValidator>  

        <br /><br />
        
        
        
        
        
        
        
        
        

        E-mail<font color="#FF0000">*</font>:<br />
        <asp:TextBox ID="Email" runat="server" Columns="70" MaxLength="254"></asp:TextBox>
        
        <asp:RequiredFieldValidator ID="ReqEmail"
        ControlToValidate="Email" 
        ErrorMessage="E-mail required."
        Display="Dynamic"
   		runat="server"
		ForeColor="Red">
        </asp:RequiredFieldValidator>  

        <asp:CustomValidator ID="CustomValidatorEmail"
        ControlToValidate="Email"
        ErrorMessage="E-mail is invalid!"
        Display="Dynamic"
        OnServerValidate="ServerValidation"
        runat="server" />


        <br /><br />
        
        
        
        
        
        
        
        
        

        Anti-Spam Question - What is the Capital of France? (Capitalise first letter)<font color="#FF0000">*</font>:

        <br />

        <asp:TextBox id="AntiSpamQuestion" runat="server" Columns="5" MaxLength="5"></asp:TextBox>
        
        <asp:RequiredFieldValidator ID="ReqAntiSpam"
        ControlToValidate="AntiSpamQuestion" 
        ErrorMessage="Answer required."
        Display="Dynamic"
   		runat="server"
		ForeColor="Red">
        </asp:RequiredFieldValidator>  
        
        <asp:CompareValidator id="Compare1" 
           ControlToValidate="AntiSpamQuestion"
           ErrorMessage="Incorrect"
           ValueToCompare="Paris"  
           Type="String"
           Display="Dynamic"
           runat="server"/>



        <br /><br />
        
        
        
        
        

        <asp:Button ID="SubmitBtn" runat="server" Text="Send Enquiry" OnClick="SubmitBtn_Click" />

    </form>

</body>
</html>
