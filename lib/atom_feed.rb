# Copyright (C) 2011 Oliver Eilhard
#
# This library is freely distributable under
# the terms of an MIT-style license.
# See COPYING or http://www.opensource.org/licenses/mit-license.php.

# This library is for parsing Atom feeds.

module AtomFeed
  VERSION = "0.3.2"

  # Atom 1.0 namespace
  NS_ATOM_2005 = "http://www.w3.org/2005/Atom"

  # OpenSearch 1.1 Draft 4 namespace
  NS_OPENSEARCH_11 = "http://a9.com/-/spec/opensearch/1.1/"

  # Well-known namespaces for use in Nokogiri
  NS = {"atom" => NS_ATOM_2005, "opensearch" => NS_OPENSEARCH_11}

  autoload :CoreExt,         'atom_feed/core_ext.rb'
  autoload :AtomFeed,        'atom_feed/atom_feed.rb'
  autoload :AtomFeedEntry,   'atom_feed/atom_feed_entry.rb'
  autoload :AtomCategory,    'atom_feed/atom_category.rb'
  autoload :AtomGenerator,   'atom_feed/atom_generator.rb'
  autoload :AtomLink,        'atom_feed/atom_link.rb'
  autoload :AtomPerson,      'atom_feed/atom_person.rb'
  autoload :OpenSearch,      'atom_feed/open_search.rb'
  autoload :OpenSearchQuery, 'atom_feed/open_search_query.rb'
end
