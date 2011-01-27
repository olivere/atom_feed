# Rakefile for AtomFeed. -*-ruby-*
require 'rake/rdoctask'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test*.rb']
end

desc "Run all tests"
task :default => [:test]

desc "Generate RDoc documentation"
task :rdoc do
  sh(*%w{rdoc --line-numbers --main README
              --title 'AtomFeed Documentation'
              --charset utf-8 -U -o doc} +
              %w{README} + Dir["lib/**/*.rb"])
end
