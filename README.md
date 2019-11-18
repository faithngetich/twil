# Authenticating Users using Authy and Clearance

This is a Rails 6 application that authenticates users using Authy and Clearance

**Installation.**

* Clone the Repo into a folder of your choice

    `git clone https://github.com/faithngetich/demo-app.git`

* Navigate inside your newly created application's folder.

   `$ cd demo-app`

* Db setup

   `$ bin/rails db:migrate`

* Install dependecies.

   `$ bundle`

* Start up the application.

    `$ rails server`

**Configuring Authy**

Grab your production API key from your[console](https://www.twilio.com/console/authy) and export it in your environment.

 `$ export AUTHY_API_KEY=Your Authy API Key`

**Setting up the webhook URL.**

* Setup and install ngrok using the [official documentation](https://dashboard.ngrok.com/get-started).

* Run `$./ngrok http 3000`

* Add the configuration to your environment configuration in the `config/environments/development.rb` to allow requests to the ngrok url.

   `config.file_watcher = ActiveSupport::EventedFileUpdateChecker`
   `config.hosts << "n9220399.ngrok.io"`

* Restart the server and try accessing the ngrok link.

* Got to your app’s authy console and set webhook endpoint/URL for authy to post it’s.
The URL looks something like this http://396ofdef.ngrok.io/authy/callback
