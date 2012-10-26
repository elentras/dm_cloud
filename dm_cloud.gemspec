# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dm_cloud/version'

Gem::Specification.new do |gem|
  gem.name          = "dm_cloud"
  gem.version       = DMCloud::VERSION
  gem.authors       = ["Jeremy Mortelette"]
  gem.email         = ["mortelette.jeremy@gmail.com"]
  gem.description   = 'This gem will simplify usage of DailyMotion Cloud API, it represent api in ruby style, with automated handler for search and upload files'
  gem.summary       = 'Simplify DailyMotion Cloud API usage'
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
