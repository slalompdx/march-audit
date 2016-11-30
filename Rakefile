task :clean do
  sh 'rm march-audit*.gem'
  sh 'rm -rf pkg' if Dir.exist?('pkg')
end

task :build do
  sh 'gem build march-audit.gemspec'
end
