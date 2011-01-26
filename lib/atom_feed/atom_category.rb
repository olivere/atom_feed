module AtomFeed
  class AtomCategory
    # Initializes the link.
    def initialize(node)
      @node = node
    end

    # Identifies the category (required).
    def term
      @node["term"]
    end

    # A categorization scheme (optional).
    def scheme
      @node["scheme"]
    end

    # Human readable label (optional).
    def label
      @node["label"]
    end
  end
end
