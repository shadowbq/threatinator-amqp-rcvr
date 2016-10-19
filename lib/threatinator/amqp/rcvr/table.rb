module Threatinator
  module Amqp
    module Rcvr

      class Table

        def initialize(backends='sqlite3')
          puts "#[threatinator-ampq-rcvr] backend - #{backends}" if Threatinator::Amqp::Rcvr::Settings.verbose
          @db =  Threatinator::Amqp::Rcvr::Backends::SQLite.new
          @db.validate!
          @db.prep

          @conn = Bunny.new(:hostname => Threatinator::Amqp::Rcvr::Settings.amqp_hostname, :automatically_recover => false)
          @conn.start
          @ch  = @conn.create_channel
          @x   = @ch.topic(Threatinator::Amqp::Rcvr::Settings.amqp_binding_topic)
          @q   = @ch.queue("", :exclusive => true)
          @q.bind(@x, :routing_key => Threatinator::Amqp::Rcvr::Settings.amqp_routing_key)
        end

        def close
          @ch.close
          @conn.close
          @db.close
          puts "#[threatinator-ampq-rcvr] All connections closed" if Threatinator::Amqp::Rcvr::Settings.verbose
          exit 0
        end

      end

      class FQDNTable < Table

        def subscribe
          dnslist = []

          puts "#[threatinator-ampq-rcvr] #{self.class } - amqp subscribing" if Threatinator::Amqp::Rcvr::Settings.verbose
          @q.subscribe(:block => true) do |delivery_info, properties, body|
            # Extract FQDN
            dataset = JSON.parse(body)
            dataset["urls"].each do |v|
              host = URI.parse(v).host
              #puts host
              if  (/[A-Za-z]/.match(host) && !(/[ ]/.match(host)))
                dnslist << host
                begin
                  @db.insert(dataset["import_time"], host, dataset["feed_provider"], dataset["feed_name"] )
                rescue SQLite3::ConstraintException
                  print "-" if Threatinator::Amqp::Rcvr::Settings.verbose
                end
              end
            end
            dataset["fqdns"].each do |v|
              dnslist << v
              begin
                @db.insert(dataset["import_time"], host, dataset["feed_provider"], dataset["feed_name"])
              rescue SQLite3::ConstraintException
                print "-" if Threatinator::Amqp::Rcvr::Settings.verbose
              end
            end
            print "." if Threatinator::Amqp::Rcvr::Settings.verbose
          end
        end #subscribe

      end

      class IPTable < Table
        def new_data()
          @db.insert()

        end
      end

    end
  end
end
