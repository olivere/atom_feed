module AtomFeed
  class AtomPerson
    # Initializes the person.
    def initialize(node)
      @node = node
    end

    # Human readable name of the person (required)
    def name
      @node.at_xpath("xmlns:name").content
    end

    # Home page for the person (optional)
    def uri
      @node.at_xpath("xmlns:uri").try(:content)
    end

    # Email address of the person (optional)
    def email
      @node.at_xpath("xmlns:email").try(:content)
    end
  end
end
