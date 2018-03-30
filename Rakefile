# Rakefile for AtomFeed. -*-ruby-*
require 'rdoc/task'
require 'rake/testtask'

desc "Run all tests"
task :default => [:test]

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

desc "Generate RDoc documentation"
RDoc::Task.new :rdoc do |rdoc|
  rdoc.title = 'AtomFeed Documentation'
  rdoc.main = "README"
  rdoc.rdoc_files.include("README")
  rdoc.rdoc_files.include("lib/**/*.rb")
  rdoc.options << "--line-numbers --charset utf-8 -U -o doc"
end
