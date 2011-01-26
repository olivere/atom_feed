module AtomFeed
  class AtomFeedEntry
    def initialize(node)
      @node = node
    end

    # Entry id (required).
    def id
      @node.at_xpath("xmlns:id").content
    end

    # Entry title (required).
    def title
      @node.at_xpath("xmlns:title").content
    end

    # Entry update date (required).
    def updated
      Time.parse @node.at_xpath("xmlns:updated").content
    end

    # Array of authors (optional).
    def authors
      nodes = @node.xpath("xmlns:author") || []
      nodes.map { |node| AtomPerson.new(node) }
    end

    # Array of links (optional).
    def links
      nodes = @node.xpath("xmlns:link") || []
      nodes.map { |node| AtomLink.new(node) }
    end

    # Content (optional)
    def content
      node = @node.at_xpath("xmlns:content")
      return nil unless node
      AtomText.new(node)
    end

    # Summary (optional)
    def summary
      node = @node.at_xpath("xmlns:summary")
      return nil unless node
      AtomText.new(node)
    end
  end
end
