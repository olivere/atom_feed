# -*- encoding: utf-8 -*-
require File.expand_path('../lib/atom_feed', __FILE__)

extra_rdoc_files = ['CHANGELOG.md', 'LICENSE', 'README.md']

Gem::Specification.new do |s|
  s.name = 'atom_feed'
  s.version = AtomFeed::VERSION.dup
  s.license = "MIT"
  s.authors = ['Oliver Eilhard']
  s.summary = %q{Parse Atom feeds}
  s.description = %q{Ruby library for parsing Atom feeds.}
  s.email = ['oliver.eilhard@gmail.com']
  s.extra_rdoc_files = extra_rdoc_files
  s.homepage = 'http://github.com/olivere/atom_feed'
  s.rdoc_options = ['--charset=UTF-8']
  s.required_ruby_version = '>= 2.6'
  s.require_paths = ['lib']
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files -- {bin,lib,spec}/*`.split("\n") + extra_rdoc_files
  s.test_files = `git ls-files -- {spec}/*`.split("\n")

  s.add_dependency("nokogiri", "~> 1.12.5")
  s.add_development_dependency("bundler", "~> 2.2.17")
  s.add_development_dependency("rdoc", "~> 6.3.2")
  s.add_development_dependency("rake", "~> 13.0.6")
  s.add_development_dependency("solargraph", "~> 0.43.0")
end
