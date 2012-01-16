class Navigation
  attr_accessor :name, :path, :title, :children, :root, :image, :parent, :controller, :action, :show, :show_children
  
  # add the default rails logger
  def logger
    Rails.logger
  end
  
  # create a new navigation Node.
  # the hash supplied should math a specific format. For more information 
  # on this format see modules.yml.
  # 
  # @params [hash] hash the hash from which to build the Navigation tree.
  # @params [boolean] root weather the node is the root of the navigation tree
  # @params [Navigation] parent the parent node of this Navigation (sub) tree
  # @params [string] name the name of the (child) node
  def initialize(hash, root = true, parent = nil, name = nil)
    self.root = root
    self.parent = parent
    self.name = name
    
    unless root
      # If this node is not the root node, set the attributes
      self.show = false
      self.image = hash["image"]
      self.title = hash["title"] || name
      
      pathname = pathify name
      self.path = hash['path'] || (parent ? "#{pathify parent.name}#{pathname}" : "#{pathname}")
      split_path = path.split(/\//)
      self.controller = hash["controller"] || split_path[1]
      self.action = hash["action"] || (split_path[2].present? ? split_path[2] : "index")
    end
    
    # Initialize the child nodes array with an empty array
    self.children = []
    if hash["sub"] or root
      (hash["sub"] || hash).each do |k,v|
        self.children << Navigation.new(v, false, self, k)
        self.children.last.name = k
      end
    end
    
    self
  end
  
  # converts the Navigation view to a hash (as it would have been when
  # loaded directly from YAML and what is used to create the navigation)
  # Basicly Navigation.new(hash) should be equal to
  # Navigation(Navigation.new(Navigation.new(hash).to_hash))
  def to_hash
    # initialize empty hash
    h = {}
    if root
      # if this node is the root node, just loop through all children
      # as the root node does not contain any additional information
      children.each do |c|
        # add the hash of the children to the initial hash
        h[c.name] = c.to_hash
      end
    else
      # If the current node is not a children, save image, path etc to the hash
      # under the appropiate keys
      h['image'] = image if image
      h['path'] = path if path
      h['title'] = title if title
      if children
        # when a child node contains other children, create a new empty hash
        # for the sub portion of the actual child hash
        h['sub'] = {}
        # and loop thorugh every of these children
        children.each do |c|
          # Add the has of the individual child to the children hash
          h['sub'][c.name] = c.to_hash
        end
      end
    end
    h
  end
  
  def to_s
    name || "Navigation root node"
  end
  
  def each_child(&proc)
    children.each &proc if children
  end
  
  def children?
    children.any?
  end
  
  def select(str)
    str = Regexp.escape str
    results = []
    if name
      if (name.match(str) or path.match(str) or title.match(str)) and show
        results << self
      end
    end
    children.each do |c|
      results.push *c.select(str)
    end
    results
  end
  
  private
  def pathify(str)
    str ? "/#{str.downcase.pluralize.gsub(/\s+/, '')}" : ""
  end
  
end