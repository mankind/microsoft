
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "microsoft/version"

Gem::Specification.new do |spec|
  spec.name          = "microsoft"
  spec.version       = Microsoft::VERSION
  spec.authors       = ["edward"]
  spec.email         = ["bauchiroad@gmail.com"]

  spec.summary       = %q{Microsoft graph integration.}
  spec.description   = %q{Enables the use of Microsoft Outlook, soon we will add Microsoft Calendars}
  spec.homepage      = "https://github.com/mankind."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "webmock", "~> 3.4.1"

  spec.add_dependency 'httparty', "~> 0.16"
end
