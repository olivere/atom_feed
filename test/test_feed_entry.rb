# encoding: utf-8

require 'atom_feed'
require 'test/unit'
require 'open-uri'
require 'fakeweb'
require 'shoulda'

class TestFeedEntry < Test::Unit::TestCase
  include AtomFeed

  context "required elements" do
    setup do
      @feed = AtomFeed.open(VALID_XML)
      @entry = @feed.entries.first
    end
    should "have one entry" do
      assert_equal 1, @feed.entries.size
    end
    should "have id element" do
      assert_equal "urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a", @entry.id
    end
    should "have title element" do
      assert_equal "Atom-Powered Robots Run Amok", @entry.title
    end
    should "have updated element" do
      assert_equal Time.utc(2002,1,13,18,30,02), @entry.updated
    end
  end

  context "optional elements" do
    setup do
      @feed = AtomFeed.open(VALID_XML)
      @entry = @feed.entries.first
    end
    should "have no authors" do
      assert @entry.authors.empty?
    end
    should "have one link" do
      assert_not_nil @entry.links
      assert_equal 1, @entry.links.size
      assert_equal "http://example.org/2003/12/13/atom03", @entry.links[0].href
    end
    should "have no content" do
      assert_nil @entry.content
    end
    should "have summary" do
      assert_equal "Some text.", @entry.summary.content
      assert_equal "Some text.", @entry.summary.to_s
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
    <updated>2002-01-13T18:30:02Z</updated>
    <summary>Some text.</summary>
  </entry>
</feed>
EOF
end