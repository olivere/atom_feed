# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'atom_feed/core_ext'
require 'atom_feed/atom_feed_entry'
require 'atom_feed/atom_category'
require 'atom_feed/atom_generator'
require 'atom_feed/atom_link'
require 'atom_feed/atom_person'
require 'atom_feed/atom_text'

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
  # AtomFeed uses Nokogiri.
  #
  class AtomFeed
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
      @doc.at_xpath("xmlns:feed/xmlns:id").content
    end

    # Feed title (required).
    def title
      @doc.at_xpath("xmlns:feed/xmlns:title").content
    end

    # Feed update date (required).
    def updated
      Time.parse @doc.at_xpath("xmlns:feed/xmlns:updated").content
    end

    # Array of Authors (optional).
    def authors
      nodes = @doc.xpath("xmlns:feed/xmlns:author") || []
      nodes.map { |node| AtomPerson.new(node) }
    end

    # Array of links (optional).
    def links
      nodes = @doc.xpath("xmlns:feed/xmlns:link") || []
      nodes.map { |node| AtomLink.new(node) }
    end

    # Array of feed entries (optional).
    def entries
      nodes = @doc.xpath("xmlns:feed/xmlns:entry") || []
      nodes.map { |node| AtomFeedEntry.new(node) }
    end

    # Array of feed categories (optional).
    def categories
      nodes = @doc.xpath("xmlns:feed/xmlns:category") || []
      nodes.map { |node| AtomCategory.new(node) }
    end

    # Array of contributors (optional).
    def contributors
      nodes = @doc.xpath("xmlns:feed/xmlns:contributor") || []
      nodes.map { |node| AtomPerson.new(node) }
    end

    # Generator (optional).
    def generator
      node = @doc.at_xpath("xmlns:feed/xmlns:generator")
      return nil unless node
      AtomGenerator.new(node)
    end

    # Icon (optional).
    def icon
      @doc.at_xpath("xmlns:feed/xmlns:icon").try(:content)
    end

    # Logo (optional).
    def logo
      @doc.at_xpath("xmlns:feed/xmlns:logo").try(:content)
    end

    # rights (optional)
    def rights
      node = @doc.at_xpath("xmlns:feed/xmlns:rights")
      return nil unless node
      AtomText.new(node)
    end

    # subtitle (optional)
    def subtitle
      node = @doc.at_xpath("xmlns:feed/xmlns:subtitle")
      return nil unless node
      AtomText.new(node)
    end

  end
end
