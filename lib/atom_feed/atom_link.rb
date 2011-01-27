module AtomFeed
  class AtomLink
    # Initializes the link.
    def initialize(node)
      @node = node
    end

    # The URI of the referenced resource (required).
    def href
      @node["href"]
    end

    # A single link relationship type (optional).
    # It could be a full URI or one of some predefined
    # values. Returns "alternate" as default.
    def rel
      @node["rel"] || "alternate"
    end

    # An alternate represenation of the entry or feed, e.g. a
    # permalink to the HTML version of the resource?
    def alternate?
      self.rel == "alternate"
    end

    # A related resource (potentially large in size and might need
    # special handling), e.g. an image or video recording?
    def enclosure?
      self.rel == "enclosure"
    end

    # A document related to the feed or entry?
    def related?
      self.rel == "related"
    end

    # The feed itself?
    def self?
      self.rel == "self"
    end

    # Source of the information provided in the entry?
    def via?
      self.rel == "via"
    end

    # Link to edit?
    def edit?
      self.rel == "edit"
    end

    # Reference to OpenSearch description document (OpenSearch extension)?
    def search?
      self.rel == "search"
    end

    # Reference to first search result in OpenSearch (OpenSearch extension)?
    def first?
      self.rel == "first"
    end

    # Reference to previous search results in OpenSearch (OpenSearch extension)?
    def previous?
      self.rel == "previous"
    end

    # Reference to next search results in OpenSearch (OpenSearch extension)?
    def next?
      self.rel == "next"
    end

    # Reference to last search result in OpenSearch (OpenSearch extension)?
    def last?
      self.rel == "last"
    end

    # Media type of the resource (optional)
    def type
      @node["type"]
    end

    # Language of the referenced resource (optional)
    def hreflang
      @node["hreflang"]
    end

    # Human readable information about the link (optional)
    def title
      @node["title"]
    end

    # Length of the resource in bytes (optional).
    def length
      @node["length"]
    end

  end
end
