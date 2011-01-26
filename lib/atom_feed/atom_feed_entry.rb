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

    # categories (optional)
    def categories
      nodes = @node.xpath("xmlns:category") || []
      nodes.map { |node| AtomCategory.new(node) }
    end

    # contributors (optional)
    def contributors
      nodes = @node.xpath("xmlns:contributor") || []
      nodes.map { |node| AtomPerson.new(node) }
    end

    # Published (optional)
    def published
      time = @node.at_xpath("xmlns:published").try(:content)
      return nil unless time
      Time.parse(time)
    end

    # source (optional)
    def source
      if node = @node.at_xpath("xmlns:source")
        AtomFeedEntry.new(node)
      end
    end

    # rights (optional)
    def rights
      node = @node.at_xpath("xmlns:rights")
      return nil unless node
      AtomText.new(node)
    end

    # extensibility

  end
end
