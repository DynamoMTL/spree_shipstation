# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_shipstation'
  s.version     = '2.0.1'
  s.summary     = 'Spree/ShipStation Integration'
  s.description = 'Integrates ShipStation API with Spree. Supports exporting shipments and importing tracking numbers'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Joshua Nussbaum'
  s.email     = 'josh@godynamo.com'
  s.homepage  = 'http://www.godynamo.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4.0.beta'

  s.add_development_dependency 'capybara', '~> 1.1.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'factory_girl', '~> 4.2.0'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end
