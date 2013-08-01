# PxFusion

A Rubygem for talking to DPS's PxFusion payment product via their SOAP API. Includes the ablity to start a transaction, and then query for the status of that transaction once the payment is complete, following the pictured flow:

![PxFusion Workflow](http://www.paymentexpress.com/DPS/media/technical/Work_Flow.png)

## Installation

Add this line to your application's Gemfile:

    gem 'pxfusion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pxfusion
    
Some configuration settings are available:
    ``` ruby
      # Your PxFusion username
      PxFusion.username = 'sample'
      
      # Your PxFusion password
      PxFusion.password = 'sample'
      
      # A global return URL
      # You can also override the return URL by passing
      # it into a Transaction constructor
      PxFusion.default_return_url = 'https://test.site/purchase'
      
      # Override the default currency to charge in
      # (Default is NZD)
      PxFusion.default_currency = 'USD'
   ```
   
   In a Rails project, you should put this configuration in an initializer or your Rails
   environment configuration. Remember, DO NOT PLACE PASSWORDS IN YOUR CODE. Instead, you 
   might want to load your configuration into environment variables, and refer to them 
   using notation like `ENV['PXFUSION_USERNAME']`.     

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

