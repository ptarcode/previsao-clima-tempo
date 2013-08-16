# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'previsao-clima-tempo/version'

Gem::Specification.new do |gem|
  gem.name          = "previsao-clima-tempo"
  gem.version       = Previsao::Clima::Tempo::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Paulo de Tarço"]
  gem.email         = ["paulopjazz@gmail.com"]
  gem.description   = "Communication with Clima Tempo accessing information about the weather of Brazil"
  gem.summary       = gem.summary
  gem.homepage      = "https://github.com/ptarco/previsao-clima-tempo"
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  
  gem.add_dependency "nokogiri", ">= 1.5.9"
  
end
