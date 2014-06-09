Spree Product Property Categories
=================================

This gem heavily modifies the existing Property and ProductProperty logic in Spree.

This gem is built for Spree 2-2-stable and hasn't been tested with any other version.

Specifically, the gem replaces the app/views/spree/products/\_properties partial and the entire administrative interface for product properties. You may choose to modify \_properties.html.erb to display the properties and categories to your desire as the basic styling is rather unappeasing.

![Admin Interface](http://i.imgur.com/LDAvhu6.png?1)


Installation
------------

Add spree_product_property_categories to your Gemfile:

```ruby
gem 'spree_product_property_categories'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_product_property_categories:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/freerunningtech/spree_product_property_categories/issues)
- Fix bugs and [submit pull requests](https://github.com/freerunningtech/spree_product_property_categories/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features


Copyright (c) 2014 FreeRunning Technologies Inc, released under the MIT License
