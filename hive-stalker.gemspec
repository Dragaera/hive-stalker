# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "hive-stalker"
  spec.version       = '0.3.0'
  spec.authors       = ["Michael Senn"]
  spec.email         = ["michael@morrolan.ch"]

  spec.summary       = %q{Binding to Natural Selection 2's Hive2 ELO system}
  # spec.description   = %q{}
  spec.homepage      = "https://bitbucket.org/Lavode/hivestalker"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "typhoeus"

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 12"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.3"
  spec.add_development_dependency "yard", "~> 0.9"
end

