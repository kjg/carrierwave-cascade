# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/cascade/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave-cascade"
  spec.version       = Carrierwave::Cascade::VERSION
  spec.authors       = ["Kevin Glowacz"]
  spec.email         = ["kevin@glowacz.info"]
  spec.description   = %q{A storage plugin for carrierwave that will
    retrieving files from a secondary storageif the file is not present in the
    primary storage. New files will always be stored in the primary storage.
    This is perfect for use while migrating from one storage to another, or to
    avoid polluting a production environment when running a staging mirror.
  }
  spec.summary       = %q{Retrieve from a secondary storage when the file is
    not in the primary storage.
  }
  spec.homepage      = "https://github.com/kjg/carrierwave-cascade"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'carrierwave', '>= 0.5.8'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.12.0'
  spec.add_development_dependency 'fog'
end
