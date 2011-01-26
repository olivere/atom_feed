module AtomFeed
  class OpenSearchQuery
    # Initializes the Open Search Query element.
    def initialize(node)
      @node = node
    end

    def role
      @node["role"]
    end

    def search_terms
      @node["searchTerms"]
    end

    def start_page
      @node["startPage"].to_i
    end

    def start_index
      @node["startIndex"].to_i
    end

    def items_per_page
      @node["itemsPerPage"].to_i
    end
  end
end
