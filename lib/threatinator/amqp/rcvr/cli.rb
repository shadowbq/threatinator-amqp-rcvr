require 'optparse'
require 'threatinator/amqp/rcvr'

module Threatinator
  module Amqp
    module Rcvr

    class CLI

      def self.invoke
        self.new
      end

      def initialize
        options = {}

        options[:fqdns] = false
        options[:ips] = false

        options[:sqlite] = false
        options[:sqlite_location] = Threatinator::Amqp::Rcvr::Settings.sql_file_location

        opt_parser = OptionParser.new do |opt|
          opt.banner = "Usage: threatinator-ampq-rcvr"
          opt.separator ""

          opt.on("-f", "--fqdns", "Store FQDNS") do
            options[:fqdns] = true
            Threatinator::Amqp::Rcvr::Settings.sql_table_name = "ipv4"
          end

          opt.on("-i", "--ips", "Store IPv4") do
            options[:ips] = true
            Threatinator::Amqp::Rcvr::Settings.sql_table_name = "fqdns"
          end

          opt.separator ""

          opt.separator "AMQP"
          opt.separator ""

          opt.on("-H", "--amqp-host=", "AMQP Hostname","  Default: #{Threatinator::Amqp::Rcvr::Settings.amqp_hostname}") do |value|
            Threatinator::Amqp::Rcvr::Settings.amqp_hostname = value
          end

          opt.on("-T", "--amqp-topic=", "AMQP Binding Topic","  Default: #{Threatinator::Amqp::Rcvr::Settings.amqp_binding_topic}") do |value|
            Threatinator::Amqp::Rcvr::Settings.amqp_binding_topic = value
          end

          opt.on("-R", "--amqp-routekey=", "AMQP Routekey","  Default: #{Threatinator::Amqp::Rcvr::Settings.amqp_routing_key}") do |value|
            Threatinator::Amqp::Rcvr::Settings.amqp_routing_key = value
          end

          opt.separator "Backend"
          opt.separator ""

          opt.on("-s", "--sqlite=", "Sqlite3 backend file location","  Default: #{options[:sqlite_location]}") do |value|
            options[:sqlite] = true
            options[:sqlite_location] = value
          end

          opt.separator "Options::"

          opt.on("-v", "--verbose", "Run verbosely") do
            options[:verbose] = true
          end

          opt.on_tail("-h","--help","Display this screen") do
            puts opt_parser
            exit 0
          end

        end

        #Verify the options
        begin
          raise unless ARGV.size > 0
          opt_parser.parse!

        #If options fail display help
        #rescue Exception => e
        #  puts e.message
        #  puts e.backtrace.inspect
        rescue
          puts opt_parser
          exit
        end

        # Boolean switch
        Threatinator::Amqp::Rcvr::Settings.verbose = options[:verbose]
        Threatinator::Amqp::Rcvr::Settings.sql_file_location = options[:sqlite_location]

        if Threatinator::Amqp::Rcvr::Settings.verbose
          puts "++++++++++++++++++++++++++++++++++++++++++++++"
          puts "threatinator-ampq-rcvr!"
          Threatinator::Amqp::Rcvr::Settings.print
          puts "++++++++++++++++++++++++++++++++++++++++++++++\n"
        end

        if options[:fqdns]
          stream = FQDNTable.new(['sqlite3'])
        end

        if options[:ips]
          stream = IPTable.new(['sqlite3'])
        end

        puts " [*] Waiting for events. To exit press CTRL+C"
        begin
          stream.subscribe
        rescue Interrupt => _
          stream.close
        end

      end

    end #Class

end
end
end #module
