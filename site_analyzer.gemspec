# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'site_analyzer/version'

Gem::Specification.new do |spec|
  spec.name          = 'site_analyzer'
  spec.version       = SiteAnalyzer::VERSION
  spec.authors       = ['Denis Savchuk']
  spec.email         = ['mordorreal@gmail.com']
  spec.date          = '2015-07-01'
  spec.summary       = 'Make report for SEO. Analyse site like SEOs like. '
  spec.description   = 'Create site report for SEO many options.'
  spec.homepage      = 'https://github.com/Mordorreal/SiteAnalyzer'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'guard-rspec', '~> 4.6'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
  spec.add_runtime_dependency 'addressable', '~> 2.3'
  spec.add_runtime_dependency 'robotstxt', '~> 0.5'
  spec.add_runtime_dependency 'terminal-table', '~> 1.5'
  spec.add_runtime_dependency 'stringex', '~> 2.5'
  spec.required_ruby_version = '~> 2.2'
end
