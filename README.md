# Threatinator::Amqp::Rcvr

This is an AMQP Client (reciever) for the Threatinator raw AMQP data feeds. It is basically a AMQP -> SQL driver.

## Installation

    $ gem install threatinator-amqp-rcvr

## Usage

```
$ ./exe/threatinator-ampq-rcvr -h
Usage: threatinator-ampq-rcvr

    -f, --fqdns                      Store FQDNS
    -i, --ips                        Store IPv4

AMQP

    -H, --amqp-host=                 AMQP Hostname
                                       Default: 127.0.0.1
    -T, --amqp-topic=                AMQP Binding Topic
                                       Default: threats
    -R, --amqp-routekey=             AMQP Routekey
                                       Default: #
Backend

    -s, --sqlite=                    Sqlite3 backend file location
                                       Default: /tmp/threat.db
Options::
    -v, --verbose                    Run verbosely
    -h, --help                       Display this screen
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shadowbq/threatinator-amqp-rcvr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

