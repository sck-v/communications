$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "communications/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "communications"
  s.version     = Communications::VERSION
  s.authors     = ["Ivan Kryak"]
  s.email       = ["kryak.iv@gmail.com"]
  s.homepage    = "https://github.com/sck-v"
  s.summary     = "Tool for easy two-sided communication between two apps"
  s.description = "Tool for easy two-sided communication between two apps"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "bunny", "~> 1.4.0"

  s.add_development_dependency "sqlite3"
end
