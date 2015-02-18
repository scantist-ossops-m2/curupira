$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "curupira/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "curupira"
  s.version     = Curupira::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paulo Moura"]
  s.email       = ["paulociecomp@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "Curupira!"
  s.description = "Solução de autenticação e autorização"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
end