Gem::Specification.new do |s|
  s.name        = 'march-audit'
  s.version     = '0.1.1'
  s.licenses    = ['MIT']
  s.summary     = "automate audit of repository branches"
  s.description = "tiny application that helps identify and cull branches that shouldn't exist"
  s.authors     = ["David Gwilliam"]
  s.email       = 'david.gwilliam@slalom.com'
  s.files       = Dir.glob('lib/**/*.rb')
  s.bindir      = 'bin'
  s.homepage    = 'https://github.com/slalompdx/march-audit'
  s.executables << 'march'
  s.add_runtime_dependency 'octokit', '~> 4.0'
  s.add_runtime_dependency 'dotenv', '~> 2.1'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.add_runtime_dependency 'chronic_duration', '~> 0.10'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rake', '~> 11.3'
end
