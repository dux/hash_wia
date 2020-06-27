version  = File.read File.expand_path '.version', File.dirname(__FILE__)
gem_name = 'hash_wia'

Gem::Specification.new gem_name, version do |gem|
  gem.summary     = 'Hash with indifferent access + goodies'
  gem.description = 'Gem provides simple access to common Ruby hash types bundled in one simple class'
  gem.authors     = ["Dino Reic"]
  gem.email       = 'reic.dino@gmail.com'
  gem.files       = Dir['./lib/**/*.rb']+['./.version']
  gem.homepage    = 'https://github.com/dux/%s' % gem_name
  gem.license     = 'MIT'
end