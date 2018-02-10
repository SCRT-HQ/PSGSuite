# Google API To PSGSuite Function Map

<!-- TOC -->

- [Google API To PSGSuite Function Map](#google-api-to-psgsuite-function-map)
    - [Admin Reports API](#admin-reports-api)
    - [Gmail API](#gmail-api)

<!-- /TOC -->
## Admin Reports API

- [ ] ActivitiesResource: The "activities" collection of methods. 
    - [x] ListRequest: Retrieves a list of activities for a specific customer and application. *Get-GSActivityReport*
    - [ ] WatchRequest: Push changes to activities
- [ ] ChannelsResource: The "channels" collection of methods.
    - [ ] StopRequest: Stop watching resources through this channel
- [x] CustomerUsageReportsResource: The "customerUsageReports" collection of methods.
    - [x] GetRequest: Retrieves a report which is a collection of properties / statistics for a specific customer. *Get-GSUsageReport*
- [x] EntityUsageReportsResource: The "entityUsageReports" collection of methods.
    - [x] GetRequest: Retrieves a report which is a collection of properties / statistics for a set of objects. *Get-GSUsageReport*
- [x] UserUsageReportResource: The "userUsageReport" collection of methods.
    - [x] GetRequest: Retrieves a report which is a collection of properties / statistics for a set of users. *Get-GSUsageReport*

## Gmail API

- [ ] DraftsResource:	The "drafts" collection of methods.
    - [ ] CreateMediaUpload:	Create media upload which supports resumable upload.
    - [ ] CreateRequest:	Creates a new draft with the DRAFT label.
    - [ ] DeleteRequest:	Immediately and permanently deletes the specified draft. Does not simply trash it.
    - [ ] GetRequest:	Gets the specified draft.
    - [ ] ListRequest:	Lists the drafts in the user's mailbox.
    - [ ] SendMediaUpload:	Send media upload which supports resumable upload.
    - [ ] SendRequest:	Sends the specified, existing draft to the recipients in the To, Cc, and Bcc headers.
    - [ ] UpdateMediaUpload:	Update media upload which supports resumable upload.
    - [ ] UpdateRequest:	Replaces a draft's content.
- [ ] GetProfileRequest:	Gets the current user's Gmail profile.
- [ ] HistoryResource:	The "history" collection of methods.
    - [ ] ListRequest:	Lists the history of all changes to the given mailbox. History results are returned in chronological order (increasing historyId).
- [ ] LabelsResource:	The "labels" collection of methods.
    - [ ] CreateRequest:	Creates a new label.
    - [ ] DeleteRequest:	Immediately and permanently deletes the specified label and removes it from any messages and threads that it is applied to.
    - [x] GetRequest:	Gets the specified label. *Get-GSGmailLabel*
    - [x] ListRequest:	Lists all labels in the user's mailbox. *Get-GSGmailLabel*
    - [ ] PatchRequest:	Updates the specified label. This method supports patch semantics.
    - [ ] UpdateRequest:	Updates the specified label.
- [ ] MessagesResource:	The "messages" collection of methods.
    - [ ] AttachmentsResource:	The "attachments" collection of methods.
        - [ ] GetRequest:	Gets the specified message attachment.
    - [ ] BatchDeleteRequest:	Deletes many messages by message ID. Provides no guarantees that messages were not already deleted or even existed at all.
    - [ ] BatchModifyRequest:	Modifies the labels on the specified messages.
    - [x] DeleteRequest:	Immediately and permanently deletes the specified message. This operation cannot be undone. Prefer messages.trash instead. *Remove-GSGmailMessage*
    - [x] GetRequest:	Gets the specified message. *Get-GSGmailMessage*
    - [ ] ImportMediaUpload:	Import media upload which supports resumable upload.
    - [ ] ImportRequest:	Imports a message into only this user's mailbox, with standard email delivery scanning and classification similar to receiving via SMTP. Does not send a message.
    - [ ] InsertMediaUpload:	Insert media upload which supports resumable upload.
    - [ ] InsertRequest:	Directly inserts a message into only this user's mailbox similar to IMAP APPEND, bypassing most scanning and classification. Does not send a message.
    - [x] ListRequest:	Lists the messages in the user's mailbox. *Get-GSGmailMessageList*
    - [ ] ModifyRequest:	Modifies the labels on the specified message.
    - [ ] SendMediaUpload:	Send media upload which supports resumable upload.
    - [x] SendRequest:	Sends the specified message to the recipients in the To, Cc, and Bcc headers. *Send-GmailMessage*
    - [x] TrashRequest:	Moves the specified message to the trash. *Remove-GSGmailMessage*
    - [x] UntrashRequest:	Removes the specified message from the trash. *Restore-GSGmailMessage*
- [ ] SettingsResource:	The "settings" collection of methods.
    - [x] FiltersResource:	The "filters" collection of methods.
        - [x] CreateRequest:	Creates a filter. *Add-GSGmailFilter*
        - [x] DeleteRequest:	Deletes a filter. *Remove-GSGmailFilter*
        - [x] GetRequest:	Gets a filter. *Get-GSGmailFilter*
        - [x] ListRequest:	Lists the message filters of a Gmail user. *Get-GSGmailFilter*
    - [ ] ForwardingAddressesResource:	The "forwardingAddresses" collection of methods.
        - [ ] CreateRequest:	Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted
        - [ ] DeleteRequest:	Deletes the specified forwarding address and revokes any verification that may have been required
        - [x] GetRequest:	Gets the specified forwarding address. *Get-GSGmailForwardingAddress*
        - [x] ListRequest:	Lists the forwarding addresses for the specified account. *Get-GSGmailForwardingAddress*
    - [ ] GetAutoForwardingRequest:	Gets the auto-forwarding setting for the specified account.
    - [ ] GetImapRequest:	Gets IMAP settings.
    - [ ] GetPopRequest:	Gets POP settings.
    - [ ] GetVacationRequest:	Gets vacation responder settings.
    - [ ] SendAsResource:	The "sendAs" collection of methods.
        - [ ] CreateRequest:	Creates a custom "from" send-as alias. If an SMTP MSA is specified, Gmail will attempt to connect to the SMTP service to validate the configuration before creating the alias. If ownership verification is required for the alias, a message will be sent to the email address and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias
        - [ ] DeleteRequest:	Deletes the specified send-as alias. Revokes any verification that may have been required for using it
        - [ ] GetRequest:	Gets the specified send-as alias. Fails with an HTTP 404 error if the specified address is not a member of the collection.
        - [ ] ListRequest:	Lists the send-as aliases for the specified account. The result includes the primary send- as address assiated with the account as well as any custom "from" aliases.
        - [ ] PatchRequest:	Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias
        - [ ] SmimeInfoResource:	The "smimeInfo" collection of methods.
            - [ ] DeleteRequest:	Deletes the specified S/MIME config for the specified send-as alias.
            - [ ] GetRequest:	Gets the specified S/MIME config for the specified send-as alias.
            - [ ] InsertRequest:	Insert (upload) the given S/MIME config for the specified send-as alias. Note that pkcs12 format is required for the key.
            - [ ] ListRequest:	Lists S/MIME configs for the specified send-as alias.
            - [ ] SetDefaultRequest:	Sets the default S/MIME config for the specified send-as alias.
            - [ ] UpdateRequest:	Updates a send-as alias. If a signature is provided, Gmail will sanitize the HTML before saving it with the alias
            - [ ] VerifyRequest:	Sends a verification email to the specified send-as alias address. The verification status must be pending
    - [ ] UpdateAutoForwardingRequest:	Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled
    - [ ] UpdateImapRequest:	Updates IMAP settings.
    - [ ] UpdatePopRequest:	Updates POP settings.
    - [ ] UpdateVacationRequest:	Updates vacation responder settings.
- [ ] StopRequest:	Stop receiving push notifications for the given user mailbox.
- [ ] ThreadsResource:	The "threads" collection of methods.
    - [ ] DeleteRequest:	Immediately and permanently deletes the specified thread. This operation cannot be undone. Prefer threads.trash instead.
    - [ ] GetRequest:	Gets the specified thread.
    - [ ] ListRequest:	Lists the threads in the user's mailbox.
    - [ ] ModifyRequest:	Modifies the labels applied to the thread. This applies to all messages in the thread.
    - [ ] TrashRequest:	Moves the specified thread to the trash.
    - [ ] UntrashRequest:	Removes the specified thread from the trash.
- [ ] WatchRequest:	Set up or update a push notification watch on the given user mailbox.