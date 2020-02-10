require_relative "lib/argon2/kdf/version"

Gem::Specification.new do |spec|
  spec.name          = "argon2-kdf"
  spec.version       = Argon2::KDF::VERSION
  spec.summary       = "Argon2 key derivation for Ruby"
  spec.homepage      = "https://github.com/ankane/argon2-kdf"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{lib,vendor}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.4"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", ">= 5"
end
