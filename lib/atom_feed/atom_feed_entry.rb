module AtomFeed
  class AtomFeedEntry

    attr_reader :node

    def initialize(node)
      @node = node
    end

    # Entry id (required).
    def id
      @node.at_xpath("atom:id", ::AtomFeed::NS).content
    end

    # Entry title (required).
    def title
      @node.at_xpath("atom:title", ::AtomFeed::NS).content
    end

    # Entry update date (required).
    def updated
      Time.parse @node.at_xpath("atom:updated", ::AtomFeed::NS).content
    end

    # Array of authors (optional).
    def authors
      nodes = @node.xpath("atom:author", ::AtomFeed::NS) || []
      nodes.map { |node| AtomPerson.new(node) }
    end

    # Array of links (optional).
    def links
      nodes = @node.xpath("atom:link", ::AtomFeed::NS) || []
      nodes.map { |node| AtomLink.new(node) }
    end

    # Content (optional)
    def content
      node = @node.at_xpath("atom:content", ::AtomFeed::NS)
      return nil unless node
      AtomText.new(node)
    end

    # Summary (optional)
    def summary
      node = @node.at_xpath("atom:summary", ::AtomFeed::NS)
      return nil unless node
      AtomText.new(node)
    end

    # categories (optional)
    def categories
      nodes = @node.xpath("atom:category", ::AtomFeed::NS) || []
      nodes.map { |node| AtomCategory.new(node) }
    end

    # contributors (optional)
    def contributors
      nodes = @node.xpath("atom:contributor", ::AtomFeed::NS) || []
      nodes.map { |node| AtomPerson.new(node) }
    end

    # Published (optional)
    def published
      time = @node.at_xpath("atom:published", ::AtomFeed::NS).try(:content)
      return nil unless time
      Time.parse(time)
    end

    # source (optional)
    def source
      if node = @node.at_xpath("atom:source", ::AtomFeed::NS)
        AtomFeedEntry.new(node)
      end
    end

    # rights (optional)
    def rights
      node = @node.at_xpath("atom:rights", ::AtomFeed::NS)
      return nil unless node
      AtomText.new(node)
    end

  end
end
