# PSGSuite
Powershell module wrapping G Suite (Google Apps) API calls in handy functions. Authentication is established using a service account via P12 key to negate the consent popup and allow for greater handsoff automation capabilities

Ready to get started? Visit the [Initial Setup page](https://github.com/nferrell/PSGSuite/wiki/Initial-Setup) and follow the directions there.

## Prerequisites
In order to use this module, you'll need to have the following:
* **Powershell 3.0 or higher** (module makes heavy use of Invoke-RestMethod).
* API Access Enabled in the Admin Console under Security
* Service Account key created and downloaded as **a P12 key file**.
* API Client access allowed for the Service Account that will be used towards the API scopes that you intend to utilize
* Domain-Wide Delegation enabled for the service account

## Tips & Tricks
* All functions support pre-acquired Access Tokens (using the _AccessToken_ parameter).
    * This is useful if you have a lot of recurring commands that leverage the same admin and scope(s) so you do not overrun the user API call quota, i.e. pulling info for a large set of emails in a user's inbox.
    * If the access token is not pre-acquired, then the _P12KeyPath_, _AppEmail_, _AdminEmail_, _CustomerID_, and _Domain_ parameters will default to reading from the PSGSuite config file (these can also be named in each function call, if preferred).
* If you plan on using this module on multiple computers or between multiple accounts on the same computer, you will need a new PSGoogle config created for each computer / user account pair. Read more here: [Using With Multiple Computers or Admins](https://github.com/nferrell/PSGSuite/wiki/Using-With-Multiple-Computers-or-Admins)

## Credits
Handling the Service Account OAuth procedure in Powershell:
- http://www.thingsthatmademeangry.com/2014/11/google-apps-oauth2-service-account.html

Initial expoloration into Google Apps management via command line:
- https://github.com/jay0lee/GAM  (thank you for all of your help along the way Jay & Ross!)
