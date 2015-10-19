$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "audit_record/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "audit_record"
  gem.version     = AuditRecord::VERSION
  gem.authors     = ["ocowchun"]
  gem.email       = ["ocowchun@gmail.com"]
  gem.homepage    = "TODO"
  gem.summary     = "TODO: Summary of AuditRecord."
  gem.description = "TODO: Description of AuditRecord."
  gem.license     = "MIT"

  gem.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  gem.test_files    = gem.files.grep(/^spec\//)

  gem.add_dependency "rails", "~> 4.2.4"
  gem.add_dependency 'rails-observers', '~> 0.1.2'

  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency 'rspec-rails', '~> 3.0'
  gem.add_development_dependency "pry"

end
