# PSGoogle
Powershell module wrapping Google Apps API calls in handy functions. Authentication is established using a service account via P12 key to negate the consent popup and allow for greater handsoff automation capabilities


## Credits
Handling the Service Account OAuth procedure in Powershell:
- http://www.thingsthatmademeangry.com/2014/11/google-apps-oauth2-service-account.html

Initial expoloration into Google Apps management via command line:
- https://github.com/jay0lee/GAM  (thank you for all of your help along the way Jay & Ross!)


## Prerequisites / How To Setup (updated 08/02/2016)
In order to use this module, you'll need to have the following:
  * Service Account Key created and downloaded as **a P12 key file**.
  * API Client access allowed for the Service Account that will be used towards the API scopes that you intend to utilize
  * (optional) Domain-Wide Delegation enabled for the service account


### Configuring the Service Account & OAuth Client
1. Connect to the [Google Developer's console](https://console.developers.google.com/)
2. Create a new project (or choose an existing one to use)
3. Under API Manager >> Credentials, select the "OAuth Consent Screen" tab
4. In the "Product name shown to users" field, enter a product name (i.e. PSGoogle), then click Save
5. Under API Manager >> Library, choose the API's that you'd like to access via Powershell. Some essentials are...
  * **Admin SDK** (Anything user, group, directory related -- HIGHLY recommend!)
  * Apps Activity API (Drive file activity reports)
  * Contacts API (Google Contact management)
  * **Drive API** (Drive file management -- HIGHLY recommend)
  * Enterprise License Manager API (user license management API)
  * Gmail API (Gmail management)
  * **Calendar API** (Google Calendar management -- HIGHLY recommend)
  * Google+ API (Google+ management)
  * **Groups Settings API** (for more granular Groups Settings management -- HIGHLY recommend)
6. Under Credentials, click the blue **Create credentials** drop-down (again), then select Service Account Key
7. On the Service Account drop down, create a new Service Account or choose a previously existing one
  * If creating a new Service Account, choose a memorable name and appropriate role in the project.
8. **Select P12 for the key type**
9. Click the blue **Create** button to initiate the download of your P12 key file. Once created, you will be taken back to the Credentials page.
  * **Save your P12 key file somewhere safe and treat it like a password -- Do not give this to anyone!!**
10. On the mid-right side of the credentials page, click 'Manage service accounts'
11. Click the menu icon on the far right next to the chosen/newly created service account, then select 'Edit'
12. Check the box to enable 'Enable Google Apps Domain-wide Delegation', then click Save
13. **Keep the Developer's Console open on the API Manager >> Credentials tab while you move on to the next section!**


### Adding API Client Access in Admin Console
1. Open a new tab the [Google Admin Console](https://admin.google.com/)
2. Go to the Security section
3. Expand 'Advanced Settings'
4. Click 'Manage API client access'
5. Open your Developer's Console tab back up to the API Manager >> Credentials tab
6. Under OAuth 2.0 client IDs, find the Service Account associated with your OAuth 2.0. It will be named 'Client for [service account name]' and have a type of 'Service account client'
7. Click the Service Account Client name to open up the details
8. Copy the Client ID, then switch tabs back to the Admin Console
9. Paste the Client ID in the left field for 'Client Name'
10. Copy / paste the following scopes on the right field for 'One or more API scopes':

[more to come soon!]
