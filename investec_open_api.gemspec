require_relative 'lib/investec_open_api/version'

Gem::Specification.new do |spec|
  spec.name          = "investec_open_api"
  spec.version       = InvestecOpenApi::VERSION
  spec.authors       = ["Markus Kuhn", "Jethro Flanagan"]
  spec.email         = ["mkk0856@gmail.com", "jethroflanagan@gmail.com"]

  spec.summary       = %q{Investec Open API Wrapper}
  spec.description   = %q{A small wrapper client for accessing Investec's Open API}
  spec.homepage      = "https://github.com/offerzen/investec_open_api"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # add runtime dependencies
  spec.add_runtime_dependency 'active_attr'
  spec.add_runtime_dependency 'faraday', '~> 1.8'
  spec.add_runtime_dependency 'faraday_middleware', '1.2.0'
  spec.add_runtime_dependency 'money'

  # add development dependencies
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
