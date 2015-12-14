$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pochette_web/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pochette_web"
  s.version     = PochetteWeb::VERSION
  s.authors     = ["Nubis"]
  s.email       = ["yo@nubis.im"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of PochetteWeb."
  s.description = "TODO: Description of PochetteWeb."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "twitter-bootstrap-rails", "~> 3.2.2"
  s.add_dependency "coffee-rails", "~> 4.0.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "haml", "~> 4.0.7"
  s.add_dependency "pochette", "~> 0.2.2"
  s.add_dependency "pochette_toshi", "~> 0.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
end
