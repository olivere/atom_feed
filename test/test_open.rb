# encoding: utf-8

require 'atom_feed'
require 'test/unit'
require 'open-uri'
require 'webmock/test_unit'

class TestOpen < Test::Unit::TestCase
  include AtomFeed

  def test_open_from_string
    assert_not_nil feed = AtomFeed.open(VALID_XML)
  end

  def test_open_from_file
    f = File.open(File.dirname(__FILE__) + "/atom.xml")
    assert_not_nil feed = AtomFeed.open(f)
    f.close
  end

  def test_open_from_the_internets
    stub_request(:get, "http://example.com/atom.xml").to_return(:status => 200, :body => VALID_XML)
    assert_not_nil feed = AtomFeed.open(URI.open("http://example.com/atom.xml").read)
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
