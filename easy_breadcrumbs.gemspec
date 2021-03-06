# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_breadcrumbs/version'

Gem::Specification.new do |spec|
  spec.name          = "easy_breadcrumbs"
  spec.version       = EasyBreadcrumbs::VERSION
  spec.authors       = ["Eliathah Boda"]
  spec.email         = ["nerboda@gmail.com"]

  spec.summary       = %q{Automatically add bootstrap breadcrumbs to your Sinatra app.}
  spec.description   = %q{Provides an `easy_breadcrumbs` view helper for automatically generating bootstrap breadcrumbs for your Sinatra Application.}
  spec.homepage      = "https://github.com/nerboda/easy_breadcrumbs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_dependency "activesupport"
  spec.add_dependency "erubis"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack-test"
end
