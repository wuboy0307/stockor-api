# Stockor API

Stockor API is a REST API for the Stockor ERP system.
It exposes the models and business logic defined in Skr::Core.

## Installation

Add this line to your application's Gemfile:

    gem 'skr-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skr-api

## Usage

It's built using the [Grape micro-framework](http://intridea.github.io/grape/) and can be mounted using Rack or other methods as outlined at: http://intridea.github.io/grape/docs/index.html#Mounting

For an example using Rails, modify the config/routes.rb file and add:

    mount Skr::API::Root => '/stockor'


## Contributing

The standard instructions are always good:

1. Fork it ( http://github.com/<my-github-username>/skr-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Really though, if you've got a feature you've added we're glad to work with you.  Get us the code however you're able to and we can figure it out.
