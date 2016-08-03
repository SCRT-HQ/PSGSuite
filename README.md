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

### Creating the Service Account Key
1. Connect to the [Google Developer's console](https://console.developers.google.com/)
2. Create a new project (or choose an existing one to use)
3. Under API Manager >> Library, choose the API's that you'd like to access. Some essentials are...
  * **Admin SDK**
  * Drive API
  * Calendar API
  * Gmail API
4. Under Credentials, click the blue **Create credentials** drop-down, then select Service Account Key
5. On the Service Account drop down, create a new Service Account or choose a previously existing one.
6. **Select P12 for the key type.**
7. Click the blue **Create** button to initiate the download of your P12 key file.
  * **Save this somewhere safe and treat it like a password -- Do not give this to anyone!!**
  * 

