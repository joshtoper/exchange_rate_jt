# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "exchange_rate_jt/version"

Gem::Specification.new do |spec|
  spec.name          = "ExchangeRateJt"
  spec.version       = ExchangeRateJt::VERSION
  spec.authors       = ["Joshua Toper"]
  spec.email         = ["work@joshtoper.co.uk"]

  spec.summary       = %q{Minimal gem for calculating exchange rates.}
  spec.description   = %q{This is a self-contained gem which calculates exchange rates from a variety of sources. The gem caches all requests so that lookups can be performant.}
  spec.homepage      = "http://www.joshtoper.co.uk"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
