Spree/ShipStation Integration
==============================

Integrates [ShipStation](http://www.shipstation.com) with [Spree](http://spreecommerce.com). It enables ShipStation to pull shipments from the system and update tracking numbers.

Configuring
-----------

Add spree_shipstation to your Gemfile

```
gem "spree_shipstation"
```

Alternatively

```
gem "spree_shipstation", git: "git://github.com/DynamoMTL/spree_shipstation.git"
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
