Gem::Specification.new do |s|
  s.name        = 'dag'
  s.version     = '0.0.8'
  s.date        = '2015-08-27'
  s.license     = 'MIT'
  s.summary     = 'Directed acyclic graphs'
  s.description = 'A very simple library for working with directed acyclic graphs'
  s.authors     = ['Kevin Rutherford']
  s.email       = 'kevin@rutherford-software.com'
  s.homepage    = 'http://github.com/kevinrutherford/dag'

  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'rspec', '~> 3'

  s.files          = `git ls-files -- lib spec [A-Z]* .rspec .yardopts`.split("\n")
  s.test_files     = `git ls-files -- spec`.split("\n")
  s.require_path   = 'lib'
end
