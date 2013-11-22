$:.unshift File.expand_path('../lib/', __FILE__)
require 'basiccache.rb'

Gem::Specification.new do |s|
  s.name        = 'basiccache'
  s.version     = BasicCache::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = 'Provides a minimal key/value caching layer'
  s.description = "Allows an application to dynamically cache values and retrieve them later"
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files test/test_*.rb`.split
  s.homepage    = 'https://github.com/akerl/basiccache'
  s.license     = 'MIT'

  %w(rubocop travis-lint parser rake coveralls rspec).each do |gem|
    s.add_development_dependency gem
  end
end

