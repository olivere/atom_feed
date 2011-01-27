module AtomFeed
  class AtomPerson
    # Initializes the person.
    def initialize(node)
      @node = node
    end

    # Human readable name of the person (required)
    def name
      @node.at_xpath("atom:name", ::AtomFeed::NS).content
    end

    # Home page for the person (optional)
    def uri
      @node.at_xpath("atom:uri", ::AtomFeed::NS).try(:content)
    end

    # Email address of the person (optional)
    def email
      @node.at_xpath("atom:email", ::AtomFeed::NS).try(:content)
    end
  end
end
