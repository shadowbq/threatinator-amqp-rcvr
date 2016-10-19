module Threatinator
  module Amqp
    module Rcvr
      module Backends

        class SQLite

          def initialize()
            @connection=_connect(Threatinator::Amqp::Rcvr::Settings.sql_file_location)
            @connection.results_as_hash = true
            @connection
          end

          def prep
            @stmt = @connection.prepare(<<-EOS)
              INSERT INTO #{Threatinator::Amqp::Rcvr::Settings.sql_table_name}(import_time, name, feed_provider, feed_name) VALUES(:import_time, :name, :feed_provider, :feed_name)
            EOS
            @connection
          end

          def validate!
            @connection.execute("PRAGMA table_info(#{Threatinator::Amqp::Rcvr::Settings.sql_table_name});") do |row|
              raise UnknownDBSchemaError, "Unknown Schema" unless ["id","feed_provider","feed_name", "import_time","name"].include? row["name"]
            end
            puts "#[threatinator-ampq-rcvr] schema validated" if Threatinator::Amqp::Rcvr::Settings.verbose
          end

          def insert(import_time, host, feed_provider, feed_name)
            @stmt.execute(:import_time => import_time, :name => host, :feed_provider => feed_provider, :feed_name => feed_name)
          end

          def close
            @stmt.close
            @connection.close
          end

          private

          def _create!
            @connection.execute(<<-EOS)
            CREATE TABLE IF NOT EXISTS #{Threatinator::Amqp::Rcvr::Settings.sql_table_name} (
                id INTEGER PRIMARY KEY,
                feed_provider varchar(255),
                feed_name varchar(255),
                import_time timestamp default (strftime('%s', 'now')),
                name varchar(255),
                CONSTRAINT name_unique UNIQUE (import_time, name)
              )
            EOS
          end

          def _connect(file)
            begin
              @connection = SQLite3::Database.new(file)
              _create!
              return @connection
            rescue SQLite3::Exception => e
              begin
                @connection = SQLite3::Database.open(file)
                return @connection
              rescue ::SQLite3::Exception => e
                puts "Exception occurred"
                puts e
                @connection.close if @connection
              end
            end

          end

        end
      end
    end
  end
end
