$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "record_auditor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "record_auditor"
  gem.version     = RecordAuditor::VERSION
  gem.authors     = ["ocowchun"]
  gem.email       = ["ocowchun@gmail.com"]
  gem.homepage    = "https://github.com/sudo-recruit/record_auditor"
  gem.summary     = "record_auditor is a gem to audit ActiveRecord change"
  gem.description = "audit ActiveRecord change"
  gem.license     = "MIT"

  gem.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  gem.test_files    = gem.files.grep(/^spec\//)

  gem.add_dependency "rails", '~> 4.2', '>= 4.2.4'
  gem.add_dependency 'rails-observers', '~> 0.1.2'

  gem.add_development_dependency 'sqlite3', '~> 1.3'
  gem.add_development_dependency 'rspec-rails', '~> 3.0'
  gem.add_development_dependency "pry", '~> 0'

end
