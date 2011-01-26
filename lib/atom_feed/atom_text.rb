module AtomFeed
  class AtomText
    # Initializes the text element.
    def initialize(node)
      @node = node
    end

    # Content of the text
    def to_s
      @node.content
    end

    alias_method :content, :to_s

    # Determines how the information is encoded.
    # Default is "text"
    def type
      @node["type"] || "text"
    end

    # Plain text
    def text?
      self.type == "text"
    end

    # Entity escaped HTML
    def html?
      self.type == "html"
    end

    # Inline XHTML
    def xhtml?
      self.type == "xhtml"
    end
  end
end
