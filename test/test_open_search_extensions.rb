# encoding: utf-8

require 'atom_feed'
require 'test/unit'
require 'open-uri'
require 'shoulda'
require 'webmock/test_unit'

class TestOpenSearchExtensions < Test::Unit::TestCase
  include AtomFeed

  context "when parsing feed with OpenSearch extensions" do
    setup do
      @feed = AtomFeed.open(VALID_XML_WITH_OPENSEARCH)
    end
    should "have opensearch extension" do
      assert_not_nil @feed.open_search
      assert @feed.open_search.present?
    end
    should "have total_results" do
      assert_equal 4230000, @feed.open_search.total_results
    end
    should "have start_index" do
      assert_equal 21, @feed.open_search.start_index
    end
    should "have items_per_page" do
      assert_equal 10, @feed.open_search.items_per_page
    end
    should "have open search queries" do
      assert_not_nil queries = @feed.open_search.queries
      assert_equal 1, queries.size
      assert_not_nil query = queries.first
      assert_equal "request", query.role
      assert_equal "New York History", query.search_terms
      assert_equal 1, query.start_page
    end
  end

  VALID_XML_WITH_OPENSEARCH = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/">
  <title>Example.com Search: New York history</title>
  <link href="http://example.com/New+York+history"/>
  <updated>2003-12-13T18:30:02Z</updated>
  <author>
    <name>Example.com, Inc.</name>
  </author>
  <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
  <opensearch:totalResults>4230000</opensearch:totalResults>
  <opensearch:startIndex>21</opensearch:startIndex>
  <opensearch:itemsPerPage>10</opensearch:itemsPerPage>
  <opensearch:Query role="request" searchTerms="New York History" startPage="1" />
  <link rel="alternate" href="http://example.com/New+York+History?pw=3" type="text/html"/>
  <link rel="self" href="http://example.com/New+York+History?pw=3&amp;format=atom" type="application/atom+xml"/>
  <link rel="first" href="http://example.com/New+York+History?pw=1&amp;format=atom" type="application/atom+xml"/>
  <link rel="previous" href="http://example.com/New+York+History?pw=2&amp;format=atom" type="application/atom+xml"/>
  <link rel="next" href="http://example.com/New+York+History?pw=4&amp;format=atom" type="application/atom+xml"/>
  <link rel="last" href="http://example.com/New+York+History?pw=42299&amp;format=atom" type="application/atom+xml"/>
  <link rel="search" type="application/opensearchdescription+xml" href="http://example.com/opensearchdescription.xml"/>
  <entry>
    <title>New York History</title>
    <link href="http://www.columbia.edu/cu/lweb/eguids/amerihist/nyc.html"/>
    <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
    <updated>2003-12-13T18:30:02Z</updated>
    <content type="text">
      ... Harlem.NYC - A virtual tour and information on
      businesses ...  with historic photos of Columbia's own New York
      neighborhood ... Internet Resources for the City's History. ...
    </content>
  </entry>
</feed>
EOF
end
