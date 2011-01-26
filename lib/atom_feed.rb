# Copyright (C) 2011 Oliver Eilhard
#
# This library is freely distributable under
# the terms of an MIT-style license.
# See COPYING or http://www.opensource.org/licenses/mit-license.php.

# This library is for parsing Atom feeds.

module AtomFeed
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
