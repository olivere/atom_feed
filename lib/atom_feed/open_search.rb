require 'atom_feed/open_search_query'

module AtomFeed
  class OpenSearch
    # Initializes the Open Search extensions.
    def initialize(node)
      @node = node
    end

    def present?
      !self.total_results.nil?
    end

    def total_results
      @node.at_xpath("atom:feed/opensearch:totalResults", ::AtomFeed::NS).content.to_i rescue nil
    end

    def start_index
      @node.at_xpath("atom:feed/opensearch:startIndex", ::AtomFeed::NS).content.to_i rescue nil
    end

=begin
    def start_page
      @node.at_xpath("atom:feed/opensearch:startPage", ::AtomFeed::NS).content.to_i rescue nil
    end
=end

    def items_per_page
      @node.at_xpath("atom:feed/opensearch:itemsPerPage", ::AtomFeed::NS).content.to_i rescue nil
    end

    # queries
    def queries
      nodes = @node.xpath("atom:feed/opensearch:Query", ::AtomFeed::NS) rescue nil
      nodes.map { |node| OpenSearchQuery.new(node) } if nodes
    end

    # first
    # previous
    # next
    # last
    # search
  end
end
