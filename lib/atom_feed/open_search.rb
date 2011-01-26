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
      @node.at_xpath("xmlns:feed/opensearch:totalResults").content.to_i rescue nil
    end

    def start_index
      @node.at_xpath("xmlns:feed/opensearch:startIndex").content.to_i rescue nil
    end

    def start_page
      @node.at_xpath("xmlns:feed/opensearch:startPage").content.to_i rescue nil
    end

    def items_per_page
      @node.at_xpath("xmlns:feed/opensearch:itemsPerPage").content.to_i rescue nil
    end

    # queries
    def queries
      nodes = @node.xpath("xmlns:feed/opensearch:Query") rescue nil
      nodes.map { |node| OpenSearchQuery.new(node) } if nodes
    end

    # first
    # previous
    # next
    # last
    # search
  end
end
