This project is built on RoR as an API-only server. More on it [here](https://guides.rubyonrails.org/api_app.html)

The project is simply a demonstration of subscription management with stripe.
It is assumed, you have a working test environment setup in [stripe.com](https://dashboard.stripe.com/test/dashboard)

## Dev environment setup


### Configure stripe

1. Get your stripe test key from devlopers section in stripe. [API Keys](https://dashboard.stripe.com/test/apikeys) as it is called.
  - Find the section called Standard keys
  - There you'll find a button "Reveal test key, beside Secret key
  - Click on it and copy the key (looks like sk_test...)
2. Add the key to your secret key base
  - For brivity, we will use the rails inbuilt support for credentials, More about it [here](https://edgeguides.rubyonrails.org/security.html#custom-credentials)
  - Rais credentials are encrypted. So they unencrypted file can be opend by rails itself
  - Type `EDITOR="code --wait" bin/rails credentials:edit` in the terminal. We are using vscode editor here. Feel free to use your favourite editor. (PS: --wait flag here is to signal vscode to wait for file to open. It takes a bit to decript or generate the file)
  - The opened file should contain the secret_key_base.
  - Add a line there
  - `stripe_secret_key: sk_test_...`
  - the sk_test... is the key we copied earlier
  - Add your webhook key `stripe_webhook_endpoint_secret: whsec_...` in a new line.
  - You can find the key in [stripe dashboard](https://dashboard.stripe.com/test/webhooks/create)
  - close the file (cmd/ctrl + w. Depends on your editor)
Note: Setting up strip test account, test cards etc is out of scope

### configure application

- Make sure you have latest version of Ruby as specified in `.ruby-version`
- Feel free to look into ways to do it. E.g using [rbenv](https://github.com/rbenv/rbenv), [rvm](https://github.com/rvm/rvm), or something else if you prefer
- Install [bundler](https://github.com/rubygems/bundler) if you have not already
- Fetch the dependency packages `bundle install`
- run pending migrations `bin/rails db:migrate`


## Running the server

`bin/rails server`


## Testing with webhooks
- Configure [strip cli](https://stripe.com/docs/stripe-cli) or [VSC stripe extension](https://marketplace.visualstudio.com/items?itemName=Stripe.vscode-stripe) to listen and forward events to your local server
- Setup product, and plans for testing in stripe dashboard (details out of scope)
- Start sending events via Stripe UI
  - create customer (customer.created) should create user in our system with billing_id
  - delete customer (customer.deleted) should remove billing_id from user
  - create subscription (customer.subscription.created)
    - On existing user should create subscription of status `unpaid`
    - On new user should create user and associate subscription
  - invoice paid (invoice.paid), should move the subscription to paid `state`
  - subscription deleted (customer.subscription.deleted)
    - Should cancel subscription for a paid subscription
    - No change for unpaid subscription

## Running Automated tests

`bin/rails test [test_file_path.rb]`
