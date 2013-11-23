$:.unshift File.expand_path('../lib/', __FILE__)
require 'version'

Gem::Specification.new do |s|
  s.name        = 'basiccache'
  s.version     = BasicCache::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = 'Provides a minimal key/value caching layer'
  s.description = "Allows an application to dynamically cache values and retrieve them later"
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  #s.files       = `git ls-files`.split
  #s.test_files  = `git ls-files spec/*`.split
  s.homepage    = 'https://github.com/akerl/basiccache'
  s.license     = 'MIT'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'travis-lint'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'parser', '~> 2.1.0.pre1'
end

