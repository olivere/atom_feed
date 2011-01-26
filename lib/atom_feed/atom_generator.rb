module AtomFeed
  class AtomGenerator
    # Initializes the generator element.
    def initialize(node)
      @node = node
    end

    # Content of the generator
    def to_s
      @node.content
    end

    alias_method :content, :to_s

    # URI (optional)
    def uri
      @node["uri"]
    end

    # Version (optional)
    def version
      @node["version"]
    end
  end
end
