# Instructions

## Requirements

A Janssen server installation with fido2 and config-api, plus casa.

## Configurations with TUI

- Enable the Agama custom script

- Enable the Agama engine

- Ensure the AS property `sessionIdUnauthenticatedUnusedLifetime` is set to 360 seconds at least

- Add project:
    
    - Deploy the archive
    
    - Export the configuration sample
    
    - Edit the file per your needs (some hints below)
    
    - Import the file back

### Github integration

Create a Github app or an OAuth app in Github. This is normally found under "Developer settings" of your Github profile. When creating the app, supply `https://<jans-host-name>/jans-auth/fl/callback` for _Authorization callback URL_. Collect the client ID and secret provided.

Prefer a Github app over an OAuth app. In this case, ensure to select:

- Expire user authorization tokens
- Allow this GitHub App to be installed by any user or organization

### Recaptcha

This is an optional feature.

The registration page of this project may be protected by reCAPTCHA v2. To do so, visit https://www.google.com/recaptcha/admin/create and register a new site:

- Select "Challenge (v2)" , then Invisible recaptcha
- Add the domain where this project is being deployed
- Pick other settings as desired
- Don't forget to hit the "Save" button
- Collect the _site key_

### ZOHO

This is an optional feature.

When the registration form is submitted, an entry is added in the Zoho CRM - specifically a lead. This requires some setup. To begin, login to https://api-console.zoho.com

#### Create a self-client

In the applications list, if there is no entry labeled "Self client", follow the instructions given. If such entry already exists, you can safely ignore the steps in this section.

Follow steps 1-4 of [this](https://www.zoho.com/crm/developer/docs/api/v2/auth-request.html#self-client) page. Collect the client ID and secret.

#### Generate a code

Generate a code (a "grant token" in Zoho terms) by following steps 5-10 given in [this](https://www.zoho.com/crm/developer/docs/api/v2/auth-request.html#self-client) page. For _Scopes_ enter `ZohoCRM.modules.leads.ALL` and for duration use the highest time available.

#### Get a refresh token

Get a refresh token at the token endpoint by presenting the code. Use this command as a guide:

```
curl -d grant_type=authorization_code -d client_id=<CLIENT ID> -d client_secret=<CLIENT SECRET> -d code=<CODE> <ACCOUNTS-URL>/oauth/v2/token
```

For `ACCOUNTS-URL` it should be safe to use `https://accounts.zoho.com` for US-based installations of Zoho. Otherwise, take a look at https://www.zoho.com/crm/developer/docs/api/v2/access-refresh.html

### SMTP

This flow requires delivery of e-mails, for this purpose AS has to be properly configured. The following is a sample configuration that would send non-signed e-mails:

```
{
    "requires_authentication": true,
    "trust_host": true,
    "connect_protection": "StartTls",
    "host": "SMTP server name",
    "port": 587,
    "smtp_authentication_account_username": "account at host dot com",
    "smtp_authentication_account_password": "encrypted password (use /opt/jans/bin/encode.py utility)",
    "from_name": "Ghost",
    "from_email_address": "account at host dot com (messages will appear sent from this acct)"
}
```

### Super Gluu

This step is required only if you wish to support Super Gluu in the flow:

- In the Fido2 configuration set the flag `enableSuperGluu` to `true`

- Ensure the content pointed to by the Super Gluu script (property `credentials_file`) is current. The last known working value for `server_uri` was `https://cloud-dev.gluu.cloud/scan/push-api-server` or `https://cloud.gluu.org/scan/push-api-server` depending on the environment 

## Onboard custom jar

In a VM environment the agama-inbound jar file is automatically copied to AS `custom/libs` path. In containers-based environments, special work is needed. Contact support. Note the jar is already found inside the project's archive.

Regardless of environment, the file `webapps/jans-auth.xml` has to be edited to account the jar file. Something like `<Set name="extraClasspath">./custom/libs/*</Set>` would be fine. 

Restart AS.

## Testing

Launch `io.jans.agamaLab.main`. Check the Agama docs to learn how to do so. Additionally you can pass `emailHint` as input parameter. 
