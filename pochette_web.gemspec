$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pochette_web/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pochette_web"
  s.version     = PochetteWeb::VERSION
  s.authors     = ["Nubis"]
  s.email       = ["yo@nubis.im"]
  s.homepage    = "https://github.com/bitex-la/pochette-web"
  s.summary     = "Source for https://pochette_sandbox.bitex.la"
  s.description = "Source for https://pochette_sandbox.bitex.la. Learn about trezor and pochette."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2"
  s.add_dependency "twitter-bootstrap-rails", "~> 3.2"
  s.add_dependency "coffee-rails", "~> 4.0"
  s.add_dependency "jquery-rails", "~> 4.0"
  s.add_dependency "haml", "~> 4.0"
  s.add_dependency "pochette", "~> 0.2"
  s.add_dependency "pochette_toshi", "~> 0.2"

  s.add_development_dependency "sqlite3", "~> 0"
end
