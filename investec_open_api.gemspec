require_relative 'lib/investec_open_api/version'

Gem::Specification.new do |spec|
  spec.name          = "investec_open_api"
  spec.version       = InvestecOpenApi::VERSION
  spec.authors       = ["Community Core Team"]
  spec.email         = ["community@make.dev"]

  spec.summary       = %q{Investec Open API Wrapper}
  spec.description   = %q{A small wrapper client for accessing Investec's Open API}
  spec.homepage      = "https://github.com/programmable-banking-community/investec_open_api"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # add runtime dependencies
  spec.add_runtime_dependency 'active_attr'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'money'

  # add development dependencies
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
