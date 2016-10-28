# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'threatinator/amqp/rcvr/version'

Gem::Specification.new do |spec|
  spec.name          = "threatinator-amqp-rcvr"
  spec.version       = Threatinator::Amqp::Rcvr::VERSION
  spec.authors       = ["shadowbq"]
  spec.email         = ["shadowbq@gmail.com"]

  spec.summary       = %q{Ruby AMQP Threatinator receiver}
  spec.description   = %q{This is a amqp receiver that dumps the data into a sql dbs for shadowbq-threatintor.}
  spec.homepage      = "https://github.com/shadowbq/threatinator-amqp-rcvr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bunny", "~> 2.5"
  spec.add_dependency 'sqlite3', "~> 1.3"
  spec.add_dependency 'json', "~> 2.0"
  # spec.add_dependency "pry"

  spec.add_development_dependency "bump", "~> 0.5"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
