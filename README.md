# PxFusion

[![Build Status](https://magnum.travis-ci.com/3months/pxfusion.png?token=FA4EnSunh4Af329WCePs&branch=master)](https://magnum.travis-ci.com/3months/pxfusion)

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

The gem wraps around PxFusion's SOAP API. Given correct credentials, it will happily build a `PxFusion` transaction for you, but then it's up to you to build the form required to submit to DPS. Any `PxFusion::Transaction` object can be passed straight to a `form_for` method though, so it oughtn't be too difficult:

``` ruby
# app/controllers/payments_controller.rb

def new
  @order = Order.find(1)
  @transaction = PxFusion::Transaction.new(amount: @order.total, reference: @order.to_param, return_url: payments_path)
  render
 end
 
 # This is the POST-back destination for PxFusion
 def create
   @order = Order.find(1)
   @transaction = PxFusion::Transaction.fetch(params[:sessionid])
   
   if @transaction.status == PxFusion.statuses[:approved]
     @order.paid!
     respond_to root_path and return
   else
     render :new
   end
 end
 ```
 
 And then your view:
 
 ``` erb
 # app/views/payments/new.html.erb
 
 <%= form_for @transaction do |f| %>
   <%= f.hidden_field :session_id, name: 'SessionId' %>
   <%= text_field_tag 'CardNumber' %>
   <%= date_select_tag 'ExpiryMonth', include_days: false %>
   <%= text_field_tag 'CardHolderName' %>
   <%= text_field_tag 'Cvc2', maxlength: 4 %>
   <%= f.submit 'Make Payment' %>
<% end %>
```

**Please read the [PxFusion docs](http://www.paymentexpress.com/Technical_Resources/Ecommerce_NonHosted/PxFusion) while implementing your payment flow to ensure you understand the process - it'll help you avoid confusing problems, which is important, as this gateway is not well documented**.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run the specs: `rspec spec`
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Think something's missing?

If you can think of a way that this gem could be easier to use, or if you've found a bug (reasonably) likely, then please [lodge an issue on Github](https://github.com/3months/pxfusion/issues/), so that we can help out. Thanks!


## If you need to regenerate the HTTP fixtures

For portability and testing speed, we use fixtures to test API calls against, rather than calling the actual API. This works usually, but if you're seeing strange results or have changed any API methods, you can rengenerate the fixtures:

1. Remove the current fixtures: `rm -r spec/fixtures`
3. Add your credentials to `spec/spec_helper.rb` **BE SURE NOT TO COMMIT THIS FILE**
4. Generate a Transaction and add the transaction ID into: `spec/pxfusion/transaction_spec.rb`
5. Run the specs 
6. Commit and pull request the fixture changes as above if necessary


