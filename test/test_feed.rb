# encoding: utf-8

require 'atom_feed'
require 'test/unit'
require 'open-uri'
require 'fakeweb'
require 'shoulda'

class TestFeed < Test::Unit::TestCase
  include AtomFeed

  context "required elements" do
    setup do
      @feed = AtomFeed.open(VALID_XML)
    end
    should "have id element" do
      assert_equal "urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6", @feed.id
    end
    should "have title element" do
      assert_equal "Example Feed", @feed.title
    end
    should "have updated element" do
      assert_equal Time.utc(2003,12,13,18,30,02), @feed.updated
    end
  end

  context "optional elements" do
    setup do
      @feed = AtomFeed.open(VALID_XML)
    end
    should "have one link" do
      assert_not_nil @feed.links
      assert_equal 1, @feed.links.size
      assert_equal "http://example.org/", @feed.links[0].href
    end
    should "have one author" do
      assert_not_nil @feed.authors
      assert_equal 1, @feed.authors.size
      assert_equal "John Doe", @feed.authors[0].name
    end
    should "have one entry" do
      assert_not_nil @feed.entries
      assert_equal 1, @feed.entries.size
    end
    should "have no categories" do
      assert @feed.categories.empty?
    end
    should "have no contributors" do
      assert @feed.contributors.empty?
    end
    should "have no generator" do
      assert_nil @feed.generator
    end
    should "have no icon" do
      assert_nil @feed.icon
    end
    should "have no logo" do
      assert_nil @feed.logo
    end
    should "have no rights" do
      assert_nil @feed.rights
    end
    should "have no subtitle" do
      assert_nil @feed.subtitle
    end
  end

  VALID_XML = <<EOF
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Example Feed</title>
  <link href="http://example.org/"/>
  <updated>2003-12-13T18:30:02Z</updated>
  <author>
    <name>John Doe</name>
  </author>
  <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
  <entry>
    <title>Atom-Powered Robots Run Amok</title>
    <link href="http://example.org/2003/12/13/atom03"/>
    <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
    <updated>2003-12-13T18:30:02Z</updated>
    <summary>Some text.</summary>
  </entry>
</feed>
EOF
end