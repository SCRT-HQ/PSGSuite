# Initial Setup

Getting started with PSGSuite.

## Prerequisites

In order to use this module, you will need the following:

* PowerShell 4.0+ or PowerShell Core 6+
* G Suite account (SuperAdmin needed for full functionality of the module)

***

## Installing the Module

### From the PowerShell Gallery

_**This will be slightly behind the GitHub repo. Please see below for installation instructions from the GitHub repo.** Installing items from the Gallery requires the latest version of the PowerShellGet module, which is available in Windows 10, in Windows Management Framework (WMF) 5.0, or in the MSI-based installer (for PowerShell 3 and 4)_

1. Open Powershell and run the following command:
    `Install-Module -Name PSGSuite -Scope CurrentUser`

For more information, please visit the [PSGSuite page on the Powershell Gallery](https://www.powershellgallery.com/packages/PSGSuite)


### From the GitHub release page

_**This will be equal to the Powershell Gallery, usually**_

**IMPORTANT: You MUST have the module 'Configuration' installed as a prerequisite! Installing the module from the repo source or the release page does not automatically install dependencies!!**

1. [Click here](https://github.com/nferrell/PSGSuite/releases) to go to the latest releases, then download the *PSGSuite.zip* file attached to the release
2. Right-click the downloaded zip, select Properties, then unblock the file.
    _This is to prevent having to unblock each file individually after unzipping._
3. Unzip the archive.
4. (Optional) Place the module somewhere in your PSModulePath.
    * You can view the paths listed by running the environment variable `$env:PSModulePath`

### Build from the GitHub repo

_**Bleeding edge fans, contributors, etc**_

**IMPORTANT: You MUST have the module 'Configuration' installed as a prerequisite! Installing the module from the repo source or the release page does not automatically install dependencies!!**

1. Clone the repo to your computer: `git clone https://github.com/scrthq/PSGSuite.git`
2. Open the cloned directory: `cd PSGSuite`
3. Build the module: `.\build.ps1`

Building with the default task list will automatically import the module at the end of the build.

If you'd like to import the compiled module in a new session, you can find it under the BuildOutput folder in the root of the repo.

#### OR

1. Fork the repo to your local
2. Import the module by loading the PSD1 file via full path or placing the local repo folder somewhere in your `$env:PSMODULEPATH`

***

## G Suite Users _with_ SuperAdmin access

### Creating the Project, Service Account and P12 Key in Google's Developer Console

1. [Click here to create a new project with the following API's enabled](https://console.developers.google.com/flows/enableapi?apiid=admin,appsactivity,contacts,driveactivity.googleapis.com,licensing,gmail,calendar,classroom.googleapis.com,docs.googleapis.com,drive,sheets.googleapis.com,slides.googleapis.com,groupssettings,chat.googleapis.com,people.googleapis.com,tasks):
    * Admin SDK
    * Apps Activity API
    * Contacts API
    * Drive Activity API (Apps Activity API v2)
    * Enterprise License Manager API
    * Gmail API
    * Google Calendar API
    * Google Classroom API
    * Google Docs API
    * Google Drive API
    * Google Sheets API
    * Google Slides API
    * Groups Settings API
    * Hangouts Chat API
    * People API
    * Tasks API
2. Leave the dropdown set to 'Create a project' and click the blue 'Continue' button.
    * If you encounter an error stating that `You may not have permission to create projects in this organization. Contact your Google Apps account admin to verify you have the Project Creator role.`, you may need to manually create a project instead as noted in [Issue #116](https://github.com/scrthq/PSGSuite/issues/116). If you are still unable to create a project manually, you will need to contact your domain's G Suite administrators to have them place you in the Project Creator role or create the project for you.
3. On the next screen, it will run the wizard to assist in adding credentials. Click the blue link that says 'service account' right above the '**Which API are you using?**' question to go to the Service Account Creation page.
4. On the Service Accounts page, click the blue button on the top of the screen to 'CREATE SERVICE ACCOUNT' and you'll be walked through the following 3 pages:
    * **Service account details:**
        1. Set the service account name to whatever you'd like and optionally add a description
        2. Click the `CREATE` button
    * **Grant this service account access to this project:**
        1. Set the Service Account permissions to _Project > Owner_
    * **Grant users access to this service account**
        1. Click the `CREATE KEY` button
        2. Set **Key type** to **P12**
        3. Click the blue `CREATE` button. You should download the P12 key file in your browser once clicking it.
        4. Click the blue `DONE` button to return to the Service accounts screen.
5. Click the 3 dots button at the right side of the service account you just created then select `Edit`.
6. Click the blue link to `SHOW DOMAIN-WIDE DELEGATION`.
7. Check the box to allow `Enable G Suite Domain-wide Delegation`. You should see additional fields appear for Product Name and Email Address.
8. Set an appropriate product name (i.e. `PSGSuite`), then click the blue `SAVE` button.
9. Once back on the Service Accounts page, click the link under where it says DwD to 'View Client ID'. You will be taken to a page that lists the AppEmail (e.g. `psgsuite@kindred-spirit-20183.iam.gserviceaccount.com`) and the ServiceAccountClientID (e.g. `10264827741861193783987`). Save these two in a Notepad, you will need them when you fill out the configuration.
10. Under [API Manager >> Library](https://console.developers.google.com/apis/dashboard), make sure the following API's are showing as enabled:
    * Admin SDK
    * Apps Activity API
    * Contacts API
    * Drive Activity API (Apps Activity API v2)
    * Enterprise License Manager API
    * Gmail API
    * Google Calendar API
    * Google Classroom API
    * Google Docs API
    * Google Drive API
    * Google Sheets API
    * Google Slides API
    * Groups Settings API
    * Hangouts Chat API
    * People API
    * Tasks API

***

### Adding API Client Access in Admin Console

1. Open a new tab or window to the [Google Admin Console](https://admin.google.com/)
2. Go to Security
3. Expand 'Advanced Settings'
4. Click 'Manage API client access'
5. Take the ServiceAccountClientID you copied to Notepad earlier (e.g. _10264827741861193783987_) and paste it in the left field for 'Client Name'
    * If you have already set up a PSGSuiteConfig, you can retrieve your ServiceAccountClientId by running `(Show-PSGSuiteConfig).ServiceAccountClientId`
6. Copy / paste the following scopes together on the right field for 'One or more API scopes':

```
https://apps-apis.google.com/a/feeds/emailsettings/2.0/,
https://mail.google.com/,
https://sites.google.com/feeds,
https://www.google.com/m8/feeds/contacts,
https://www.googleapis.com/auth/activity,
https://www.googleapis.com/auth/admin.datatransfer,
https://www.googleapis.com/auth/admin.directory,
https://www.googleapis.com/auth/admin.directory.customer,
https://www.googleapis.com/auth/admin.directory.device.chromeos,
https://www.googleapis.com/auth/admin.directory.device.mobile,
https://www.googleapis.com/auth/admin.directory.domain,
https://www.googleapis.com/auth/admin.directory.group,
https://www.googleapis.com/auth/admin.directory.orgunit,
https://www.googleapis.com/auth/admin.directory.resource.calendar,
https://www.googleapis.com/auth/admin.directory.rolemanagement,
https://www.googleapis.com/auth/admin.directory.rolemanagement.readonly,
https://www.googleapis.com/auth/admin.directory.user,
https://www.googleapis.com/auth/admin.directory.user.readonly,
https://www.googleapis.com/auth/admin.directory.user.security,
https://www.googleapis.com/auth/admin.directory.userschema,
https://www.googleapis.com/auth/admin.reports.audit.readonly,
https://www.googleapis.com/auth/admin.reports.usage.readonly,
https://www.googleapis.com/auth/apps.groups.settings,
https://www.googleapis.com/auth/apps.licensing,
https://www.googleapis.com/auth/calendar,
https://www.googleapis.com/auth/chat.bot,
https://www.googleapis.com/auth/classroom.announcements,
https://www.googleapis.com/auth/classroom.courses,
https://www.googleapis.com/auth/classroom.coursework.me,
https://www.googleapis.com/auth/classroom.coursework.students,
https://www.googleapis.com/auth/classroom.guardianlinks.students,
https://www.googleapis.com/auth/classroom.profile.emails,
https://www.googleapis.com/auth/classroom.profile.photos,
https://www.googleapis.com/auth/classroom.push-notifications,
https://www.googleapis.com/auth/classroom.rosters,
https://www.googleapis.com/auth/classroom.rosters.readonly,
https://www.googleapis.com/auth/drive,
https://www.googleapis.com/auth/gmail.settings.basic,
https://www.googleapis.com/auth/gmail.settings.sharing,
https://www.googleapis.com/auth/plus.login,
https://www.googleapis.com/auth/plus.me,
https://www.googleapis.com/auth/tasks,
https://www.googleapis.com/auth/tasks.readonly,
https://www.googleapis.com/auth/userinfo.email,
https://www.googleapis.com/auth/userinfo.profile
```

* _Although the module does not use all of these scopes currently, additional functions are being built to leverage this entire list._

## Free Google Account Users and G Suite Users _without_ SuperAdmin access

If you are not a G Suite super admin or even a G Suite user at all, you can still use PSGSuite for the following APIs:

* Contacts API
* Gmail API
* Google Calendar API
* Google Docs API
* Google Drive API
* Google Sheets API
* Google Slides API
* People API (new Contacts API)
* Tasks API

You will also need to take a slightly different route when creating credentials and create an OAuth Client ID instead of a Service Account and P12 Key.

### Creating the Project and Client ID/Secret in Google's Developer Console

1. [Click here to create a new project with the following API's enabled](https://console.developers.google.com/flows/enableapi?apiid=contacts,calendar,gmail,docs.googleapis.com,drive,sheets.googleapis.com,slides.googleapis.com,people.googleapis.com,tasks):
    * Contacts API
    * Gmail API
    * Google Calendar API
    * Google Docs API
    * Google Drive API
    * Google Sheets API
    * Google Slides API
    * People API (new Contacts API)
    * Tasks API

        ![image](https://user-images.githubusercontent.com/12724445/50328194-da546100-04b7-11e9-9ddd-c151fc8e83d3.png)
2. Leave the dropdown set to `Create a project` and click the blue 'Continue' button.
    * If you encounter an error stating that `You may not have permission to create projects in this organization. Contact your Google Apps account admin to verify you have the Project Creator role.`, you may need to manually create a project instead as noted in [Issue #116](https://github.com/scrthq/PSGSuite/issues/116).
    * If you are still unable to create a project manually, you will need to contact your domain's G Suite administrators to have them place you in the Project Creator role or create the project for you.
3. On the next screen, it will run the wizard to assist in adding credentials. Click the blue link that says `client ID` right above the '**Which API are you using?**' question to go to the OAuth Client ID Creation page:
    ![image](https://user-images.githubusercontent.com/12724445/50328262-0bcd2c80-04b8-11e9-8ffe-32ee580880c0.png)
4. On the OAuth Client ID creation page, click the blue button on the top of the screen to `Configure consent screen`:
    ![image](https://user-images.githubusercontent.com/12724445/50328306-33bc9000-04b8-11e9-85d7-94a6827a312e.png)
5. On the OAuth consent screen...
    ![image](https://user-images.githubusercontent.com/12724445/50328331-4f279b00-04b8-11e9-86cb-6c33d5af1a77.png)
    1. Set the Application Name. This is what you will see when authorizing the Console Project access to you data via API.
    2. Under `Scopes for Google APIs`, click the `Add scope` button.
    3. Check the check box on the top-left of the pop-up to check all of the boxes, then click `Add` on the bottom-right of the pop-up.
        ![image](https://user-images.githubusercontent.com/12724445/50328360-741c0e00-04b8-11e9-82e4-667bebd1210e.png)
    4. Scroll to the bottom of the OAuth consent screen, the click the blue `Save` button.
6. Once saved, scroll up to the top of the page then click the main `Credentials` tab.
7. Click the drop-down button to `Create credentials`, then select `OAuth client ID`.
8. Choose `Other` as the Application type and enter a friendly name such as PSGSuite, then click the blue `Create` button:
    ![image](https://user-images.githubusercontent.com/12724445/50328408-9877ea80-04b8-11e9-8004-ee071db4b6a7.png)
9. Once created, you'll get a pop-up with the client_id / client_secrets info, just click ok to close the pop-up:
    ![image](https://user-images.githubusercontent.com/12724445/50328462-c9f0b600-04b8-11e9-9d5d-da0edc108e17.png)
10. Once back on the Credentials screen, click the ⬇️ icon on the far right next to your new OAuth Client ID to download the client_secrets.json file to your preferred location:
    ![image](https://user-images.githubusercontent.com/12724445/50303600-320cb100-0453-11e9-84da-3f70b322e836.png)

***

## Creating the PSGSuite Configuration File

1. Import the module:
    * Module located in PSModulePath: ```Import-Module PSGSuite```
    * or somewhere else: ```Import-Module C:\Path\To\PSGSuite\PSGSuite.psd1```
2. Have the following information available to paste during Step 3:
    * _**G Suite SuperAdmins**_
        * **P12KeyPath**: This is the full path to the P12 file that you created during Step 9 of [Creating the Project, Service Account and P12 Key in Google's Developer Console](#creating-the-project-service-account-and-p12-key-in-googles-developer-console)
        * **AppEmail**: This is email address for the service account created earlier. It will look something like this:
            * _{service account name}_@_{project name}_.iam.gserviceaccount.com
        * **AdminEmail**: This is email address for the SuperAdmin account that created the project (usually your email)
        * **CustomerId**: This is the Customer ID of the G Suite account. If you do not know it currently, you can set it later. After importing the module, you can run ```(Get-GSUser).CustomerId``` and view the Customer ID in the response.
        * **Domain**: This is the primary domain name for the customer, i.e. _scrthq.com_
        * **Preference**: This is referenced by certain functions that allow either the Customer ID or Domain to be queried against. You can choose between "CustomerID" or "Domain" for this value.
        * **Service Account Client ID**: This stores the Service Account Client ID to allow easy callback without having to open the project page. It is purely a convenience parameter. The Service Account Client ID is the large integer that you copy during Steps 7 & 8 while [Adding API Client Access in Admin Console](#adding-api-client-access-in-admin-console)
    * _**Free account / G Suite standard users**_
        > Free accounts only need 2 pieces of information in a config for PSGSuite to work with the APIs available to them: ClientSecretsPath and AdminEmail.
        * **ClientSecretsPath**: This is the full path to the JSON file that you downloaded during Step 10 of [Creating the Project and Client ID/Secret in Google's Developer Console](#creating-the-project-and-client-idsecret-in-googles-developer-console)
        * **AdminEmail**: This is the email address for your account.
3. Run the appropriate command from the following to create the config file using the values from Step 2 of this section to replace the variables below:

      _**G Suite SuperAdmins**_

    ```powershell
    Set-PSGSuiteConfig -ConfigName MyConfig -SetAsDefaultConfig -P12KeyPath $P12KeyPath -AppEmail $AppEmail -AdminEmail $AdminEmail -CustomerID $CustomerID -Domain $Domain -Preference $Preference -ServiceAccountClientID $ServiceAccountClientID
    ```

    _**Free account / G Suite standard users**_

    ```powershell
    Set-PSGSuiteConfig -ConfigName MyConfig -SetAsDefaultConfig -ClientSecretsPath $ClientSecretsPath -AdminEmail $AdminEmail
    ```

    Here's another way to set multiple configs at the same time:

    ```powershell
    @(
        @{
            SetAsDefaultConfig     = $true
            ConfigName             = "GSuite"
            P12KeyPath             = "C:\P12s\PSGSuite.p12"
            AppEmail               = "psgsuite@developer-shore.iam.gserviceaccount.com"
            AdminEmail             = "admin@mydomain.io"
            CustomerID             = "C021xxxxxx"
            Domain                 = "mydomain.io"
            Preference             = "CustomerID"
            ServiceAccountClientID = "98723498723489723498239"
        }
        @{
            ConfigName             = "Gmail"
            ClientSecretsPath      = "C:\Keys\client_secret.json"
            AdminEmail             = "mypersonalinbox@gmail.com"
        }
    ) | ForEach-Object {
        $props = $_
        Set-PSGSuiteConfig @props
    }
    ```

***

## First-time authentication for free/non-admin accounts

If you are using a `client_secrets.json` for your configuration, you must also complete OAuth in browser to finalize your configuration. This will generate your `refresh_token` and initial `access_token` for the scopes listed below. Follow these steps to complete your configuration:

1. Import the module: `Import-Module PSGSuite`
2. Run `Get-GSGmailProfile -Verbose` (or any other Gmail, Drive, Calendar, Contacts or Tasks command) to trigger the authentication/authorization process:
    * If you are using Windows PowerShell, you should see your browser open with a Google login prompt:
        1. Authenticate using the AdminEmail account configured with `Set-PSGSuiteConfig`.
        2. Allow PSGSuite to access the below scopes on your account that you desire.
        3. You should see a message in your browser tab stating the following once complete: `Received verification code. You may now close this window.`

    * If you are using PowerShell Core (6+), you will be provided a URL to visit to complete authentication/authorization:
        1. Open your browser and go the the URL provided in the console output.
        2. Authenticate using the AdminEmail account configured with `Set-PSGSuiteConfig`.
        3. Allow PSGSuite to access the below scopes on your account that you desire.
        4. You should see a pop-up in your browser with a code to copy. Select and copy or click the button to the right of the code to copy, then paste the code back in your console where prompted, then hit `Enter`.
3. You should see the command complete successfully at this point.

* Scopes included with `client_secrets.json` auth:
    * https://www.google.com/m8/feeds
    * https://mail.google.com
    * https://www.googleapis.com/auth/gmail.settings.basic
    * https://www.googleapis.com/auth/gmail.settings.sharing
    * https://www.googleapis.com/auth/calendar
    * https://www.googleapis.com/auth/drive
    * https://www.googleapis.com/auth/tasks
    * https://www.googleapis.com/auth/tasks.readonly
* Screenshots of the PowerShell Core process:

![image](https://user-images.githubusercontent.com/12724445/50432027-bb2d4900-0894-11e9-8aa7-fe5f22e8cdc6.png)

![image](https://user-images.githubusercontent.com/12724445/50432132-63dba880-0895-11e9-8c96-ba23bf994757.png)

![image](https://user-images.githubusercontent.com/12724445/50432170-99809180-0895-11e9-87db-866450e7f6bf.png)
