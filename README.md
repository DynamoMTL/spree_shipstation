Spree/ShipStation Integration
==============================

Integrates [ShipStation](http://www.shipstation.com) with [Spree](http://spreecommerce.com). It enables ShipStation to pull shipments from the system and update tracking numbers.

For documentation on API, see [doc/ShipStationCustomStoreDevGuide.pdf](https://github.com/DynamoMTL/spree_shipstation/blob/master/doc/ShipStationCustomStoreDevGuide.pdf)

Configuring
-----------

Add spree_shipstation to your Gemfile

```ruby
gem "spree_shipstation"
```

Alternatively

```ruby
gem "spree_shipstation", git: "git://github.com/DynamoMTL/spree_shipstation.git"
```

Run bundler

    $ bundle

Configure the ShipStation API username and password. This can be done in an initializer

```ruby
# config/initializers/shipstation.rb

if Rails.env.production?
  Spree::Config.shipstation_username = "brett"
  Spree::Config.shipstation_password = "hull"
else
  Spree::Config.shipstation_username = "jody"
  Spree::Config.shipstation_password = "hull"
end

Spree::Config.shipstation_weight_units = "Grams" # Grams, Ounces or Pounds
```


Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app

To run tests:

    $ bundle exec rspec spec

To run tests with guard (preferred):
    
    $ bundle exec guard

Copyright (c) 2013 Dynamo, released under the New BSD License
