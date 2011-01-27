# encoding: utf-8

require 'nokogiri'
require 'atom_feed/core_ext'
require 'atom_feed/atom_feed_entry'
require 'atom_feed/atom_category'
require 'atom_feed/atom_generator'
require 'atom_feed/atom_link'
require 'atom_feed/atom_person'
require 'atom_feed/atom_text'
require 'atom_feed/open_search'

module AtomFeed
  # AtomFeed::AtomFeed is the central place for
  # working with feeds in the Atom format.
  #
  # Opening an atom feed from the network or a file system
  # is done like this:
  #
  #   feed = AtomFeed::AtomFeed.open(open("http://example.com/atom.xml"))
  #
  # If you have a file you should do:
  #
  #   f = File.open("feed.xml")
  #   feed = AtomFeed::AtomFeed.open(f)
  #   f.close
  #
  # If you have an XML string you can do:
  #
  #   feed = AtomFeed::AtomFeed.open("<feed ...")
  #
  # One can open and parse the feed like so:
  #
  #   AtomFeed::AtomFeed.open(...) do |feed|
  #     puts feed.title
  #     feed.entries do |entry|
  #       puts entry.title
  #     end
  #   end
  #
  # You can access OpenSearch extensions by using +AtomFeed.open_search+.
  # Access to other embedded XML types are available by using AtomFeed.doc+
  # directly. It's a +Nokogiri::XML+ instance.
  #
  # AtomFeed uses Nokogiri for parsing.
  #
  class AtomFeed

    attr_reader :doc

    def initialize(doc)
      @doc = doc
    end

    def self.open(string_or_io, url = nil, encoding = nil)
      doc = Nokogiri::XML(string_or_io, url, encoding)
      feed = AtomFeed.new(doc)
      yield feed if block_given?
      feed
    end

    # Feed id (required).
    def id
      @doc.at_xpath("atom:feed/atom:id", ::AtomFeed::NS).content
    end

    # Feed title (required).
    def title
      @doc.at_xpath("atom:feed/atom:title", ::AtomFeed::NS).content
    end

    # Feed update date (required).
    def updated
      Time.parse @doc.at_xpath("atom:feed/atom:updated", ::AtomFeed::NS).content
    end

    # Array of Authors (optional).
    def authors
      nodes = @doc.xpath("atom:feed/atom:author", ::AtomFeed::NS) || []
      nodes.map { |node| AtomPerson.new(node) }
    end

    # Array of links (optional).
    def links
      nodes = @doc.xpath("atom:feed/atom:link", ::AtomFeed::NS) || []
      nodes.map { |node| AtomLink.new(node) }
    end

    # Array of feed entries (optional).
    def entries
      nodes = @doc.xpath("atom:feed/atom:entry", ::AtomFeed::NS) || []
      nodes.map { |node| AtomFeedEntry.new(node) }
    end

    # Array of feed categories (optional).
    def categories
      nodes = @doc.xpath("atom:feed/atom:category", ::AtomFeed::NS) || []
      nodes.map { |node| AtomCategory.new(node) }
    end

    # Array of contributors (optional).
    def contributors
      nodes = @doc.xpath("atom:feed/atom:contributor", ::AtomFeed::NS) || []
      nodes.map { |node| AtomPerson.new(node) }
    end

    # Generator (optional).
    def generator
      node = @doc.at_xpath("atom:feed/atom:generator", ::AtomFeed::NS)
      return nil unless node
      AtomGenerator.new(node)
    end

    # Icon (optional).
    def icon
      @doc.at_xpath("atom:feed/atom:icon", ::AtomFeed::NS).try(:content)
    end

    # Logo (optional).
    def logo
      @doc.at_xpath("atom:feed/atom:logo", ::AtomFeed::NS).try(:content)
    end

    # rights (optional)
    def rights
      node = @doc.at_xpath("atom:feed/atom:rights", ::AtomFeed::NS)
      return nil unless node
      AtomText.new(node)
    end

    # subtitle (optional)
    def subtitle
      node = @doc.at_xpath("atom:feed/atom:subtitle", ::AtomFeed::NS)
      return nil unless node
      AtomText.new(node)
    end

    # Open Search extensions (optional)
    def open_search
      @open_search ||= OpenSearch.new(@doc)
    end

  end
end
