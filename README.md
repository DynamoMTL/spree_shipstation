Spree/ShipStation Integration
==============================

Integrates [ShipStation](http://www.shipstation.com) with [Spree](http://spreecommerce.com). It enables ShipStation to pull shipments from the system and update tracking numbers.

For documentation on the API, see [doc/ShipStationCustomStoreDevGuide.pdf](https://github.com/DynamoMTL/spree_shipstation/blob/master/doc/ShipStationCustomStoreDevGuide.pdf?raw=true)

Configuring Spree
-----------

Add spree_shipstation to your Gemfile:

```ruby
gem "spree_shipstation"
```

Alternatively you can use the git repo directly:

```ruby
gem "spree_shipstation", git: "git://github.com/DynamoMTL/spree_shipstation.git"
```

Then, run bundler

    $ bundle

Configure the ShipStation API username and password. This can be done in the app's spree initializer

```ruby
# config/initializers/spree.rb
Spree.config do |config|
  if Rails.env.production?
    config.shipstation_username = "brett"
    config.shipstation_password = "hull"
  else
    config.shipstation_username = "jody"
    config.shipstation_password = "hull"
  end

  config.shipstation_weight_units = "Grams" # Grams, Ounces or Pounds

  # if you prefer to send notifications via shipstation
  config.send_shipped_email = false
end
```

For deployment on Heroku, you can configure the API username/password with environment variables:

```ruby
# config/initializers/spree.rb
Spree.config do |config|
  config.shipstation_username = ENV['SHIPSTATION_USERNAME']
  config.shipstation_password = ENV['SHIPSTATION_PASSWORD']


  config.shipstation_weight_units = "Grams" # Grams, Ounces or Pounds
  config.send_shipped_email = false
end
```

And you can configure them with:

  $ heroku config:set SHIPSTATION_USERNAME=brett SHIPSTATION_PASSWORD=hull

Configuring ShipStation
-----------------------

To do this, go to **Settings** and select **Stores**. Then click **Add Store**, scroll down and choose the **Custom Store** option.

- For **Username**, enter the username defined in your config
- For **Password**, enter the password defined in your config
- For **URL to custom page**, enter the url: `https://domain.tld/shipstation.xml`
- For **Unpaid Status** enter `pending`
- For **Paid Status** enter `ready`
- For **Shipped Status** enter `shipped`
- For **Cancelled Status** enter `cancelled`


Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app

To run tests:

    $ bundle exec rspec spec

To run tests with guard (preferred):
    
    $ bundle exec guard


Caveats
-------
- If you change the shipping method of an order in ShipStation, the change will not be reflected in Spree and the tracking link might not work

Copyright (c) 2013 Dynamo, released under the New BSD License
