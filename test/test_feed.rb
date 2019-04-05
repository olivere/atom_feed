# encoding: utf-8

require 'atom_feed'
require 'test/unit'
require 'open-uri'
require 'shoulda'
require 'webmock/test_unit'

class TestFeed < Test::Unit::TestCase
  include AtomFeed

  def setup
    @feed = AtomFeed.open(VALID_XML)
  end

  context "on required elements" do
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

  context "on optional elements" do
    context "such as links" do
      should "be empty if missing" do
        xml = <<EOF
      <?xml version="1.0" encoding="utf-8"?>
      <feed xmlns="http://www.w3.org/2005/Atom">
        <title>Example Feed</title>
        <updated>2003-12-13T18:30:02Z</updated>
        <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
      </feed>
EOF
        feed = AtomFeed.open(xml)
        assert feed.links.empty?
      end
      should "have one link elements" do
        assert_not_nil @feed.links
        assert_equal 1, @feed.links.size
        assert_equal "http://example.org/", @feed.links[0].href
      end
      should "find link to self" do
        xml = <<EOF
      <?xml version="1.0" encoding="utf-8"?>
      <feed xmlns="http://www.w3.org/2005/Atom">
        <title>Example Feed</title>
        <updated>2003-12-13T18:30:02Z</updated>
        <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
        <link rel="self" href="/feed"/>
      </feed>
EOF
        feed = AtomFeed.open(xml)
        assert_equal 1, feed.links.size
        assert_equal "self", feed.links[0].rel
        assert_equal "/feed", feed.links[0].href
        assert feed.links[0].self?
      end
    end
    context "such as author elements" do
      should "have one author" do
        assert_not_nil @feed.authors
        assert_equal 1, @feed.authors.size
        assert_equal "John Doe", @feed.authors[0].name
      end
    end
    context "such as entry elements" do
      should "be empty without entries" do
          xml = <<EOF
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>Example Feed</title>
          <updated>2003-12-13T18:30:02Z</updated>
          <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
        </feed>
EOF
        feed = AtomFeed.open(xml)
        assert feed.entries.empty?
      end
      should "have one entry" do
        assert_not_nil @feed.entries
        assert_equal 1, @feed.entries.size
      end
      should "have two entries and keep order" do
          xml = <<EOF
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>Example Feed</title>
          <updated>2003-12-13T18:30:02Z</updated>
          <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
          <entry>
            <title>Atom-Powered Robots Run Amok</title>
            <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
            <updated>2003-12-13T18:30:02Z</updated>
            <summary>Some text.</summary>
          </entry>
          <entry>
            <title>RSS is for nuts</title>
            <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6b</id>
            <updated>2003-12-13T18:30:03Z</updated>
            <summary>Another entry.</summary>
          </entry>
        </feed>
EOF
        feed = AtomFeed.open(xml)
        assert_not_nil feed.entries
        assert !feed.entries.empty?
        assert_equal 2, feed.entries.size
        assert_equal "Atom-Powered Robots Run Amok", feed.entries[0].title
        assert_equal "RSS is for nuts", feed.entries[1].title
      end
    end
    context "such as categories element" do
      should "be empty without categories" do
        assert @feed.categories.empty?
      end
      should "have two categories and keep order" do
          xml = <<EOF
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>Example Feed</title>
          <updated>2003-12-13T18:30:02Z</updated>
          <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
          <category term="technology"/>
          <category term="aggregators" scheme="http://schemas.com/" label="Human-readable label" />
        </feed>
EOF
        feed = AtomFeed.open(xml)
        assert_not_nil feed.categories
        assert !feed.categories.empty?
        assert_equal 2, feed.categories.size
        assert_equal "technology", feed.categories[0].term
        assert_equal "aggregators", feed.categories[1].term
        assert_equal "http://schemas.com/", feed.categories[1].scheme
        assert_equal "Human-readable label", feed.categories[1].label
      end
    end
    context "such as contributors element" do
      should "be empty" do
        assert @feed.contributors.empty?
      end
      should "have two categories and keep order" do
          xml = <<EOF
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>Example Feed</title>
          <updated>2003-12-13T18:30:02Z</updated>
          <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
          <contributor>
            <name>Joe Biden</name>
          </contributor>
          <contributor>
            <name>Steve Jobs</name>
            <uri>http://fakestevejobs.com/</uri>
            <email>me@fakestevejobs.com</email>
          </contributor>
        </feed>
EOF
        feed = AtomFeed.open(xml)
        assert_not_nil feed.contributors
        assert !feed.contributors.empty?
        assert_equal 2, feed.contributors.size
        assert_equal "Joe Biden", feed.contributors[0].name
        assert_equal "Steve Jobs", feed.contributors[1].name
        assert_equal "http://fakestevejobs.com/", feed.contributors[1].uri
        assert_equal "me@fakestevejobs.com", feed.contributors[1].email
      end
    end
    context "such as generator element" do
      should "be nil when missing" do
        assert_nil @feed.generator
      end
      should "have valid attributes" do
          xml = <<EOF
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>Example Feed</title>
          <updated>2003-12-13T18:30:02Z</updated>
          <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
          <generator uri="/myblog.php" version="1.0">Example toolkit</generator>
        </feed>
EOF
        feed = AtomFeed.open(xml)
        assert_not_nil feed.generator
        assert_equal "Example toolkit", feed.generator.to_s
        assert_equal "Example toolkit", feed.generator.content
        assert_equal "/myblog.php", feed.generator.uri
        assert_equal "1.0", feed.generator.version
      end
    end
    context "such as icon element" do
      should "be nil if missing" do
        assert_nil @feed.icon
      end
      should "have valid attributes" do
          xml = <<EOF
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>Example Feed</title>
          <updated>2003-12-13T18:30:02Z</updated>
          <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
          <icon>/icon.jpg</icon>
        </feed>
EOF
        feed = AtomFeed.open(xml)
        assert_not_nil feed.icon
        assert_equal "/icon.jpg", feed.icon
      end
    end
    context "such as logo element" do
      should "be nil if missing" do
        assert_nil @feed.logo
      end
      should "have valid attributes" do
          xml = <<EOF
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>Example Feed</title>
          <updated>2003-12-13T18:30:02Z</updated>
          <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
          <logo>/logo.jpg</logo>
        </feed>
EOF
        feed = AtomFeed.open(xml)
        assert_not_nil feed.logo
        assert_equal "/logo.jpg", feed.logo
      end
    end
    context "such as rights element" do
      should "be nil" do
        assert_nil @feed.rights
      end
    end
    context "such as subtitle element" do
      should "be nil" do
        assert_nil @feed.subtitle
      end
    end
    context "such as open search extensions" do
      should "be missing" do
        assert_not_nil @feed.open_search
        assert !@feed.open_search.present?
      end
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
