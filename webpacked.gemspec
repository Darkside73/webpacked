$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'webpacked/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'webpacked'
  s.version     = Webpacked::VERSION
  s.authors     = ['Andrey Garbuz']
  s.email       = ['andrey.garbuz@gmail.com']
  s.homepage    = 'https://github.com/Darkside73/webpacked'
  s.summary     = 'Easy webpack and Rails integration'
  s.description = 'Ready for production gem to use webpack and hot reload within Rails application'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 3.2.0'
  s.add_development_dependency 'rspec'

  s.required_ruby_version = '>= 2.2.2'
end
