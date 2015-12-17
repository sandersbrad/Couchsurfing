require 'neo4j'
require_relative 'relationship'
require_relative 'user'

#specify file path here
csv_file = 'sample.csv'

# initialize database
system 'bundle exec rake neo4j:start[development]'

#open new session
Neo4j::Session.open(:server_db)

class Graph
  def initialize(csv_file)
    @nodes = {}
    @csv_file = csv_file
    build_graph(@csv_file)
  end

  def build_graph(csv_file)
    File.open(csv_file).each_line.with_index do |relationship, index|
      begin
        #parse CSV line to two entries
        from_user, to_user = parse_entry(relationship)

        #find node in hash or create new node
        from_node = find_or_create_node(from_user)
        to_node = find_or_create_node(to_user)

        #create bidirectional relationship
        create_relationship(from_node, to_node)
        create_relationship(to_node, from_node)

      #rescue any errors, log them with line number, and continue
      rescue => error
        p "Line #{index + 1}: #{error.message}"
      end
    end
  end

  def parse_entry(entry)
    first, second = entry.split(',')

    if !first || !second
      raise 'Missing Entry'
    end

    first = first.chomp
    second = second.chomp

    if first =~ /\D/ || second =~ /\D/
      raise 'Entry contains non-numeric values'
    end

    return [first, second]
  end

  def find_or_create_node(user_id)
    #utilize O(1) lookup time of hash
    node = @nodes[user_id] || User.create(user_id: user_id)
    @nodes[user_id] = node
    node
  end

  def create_relationship(from_node, to_node)
    Relationship.create(from_node: from_node, to_node: to_node)
  end
end

graph = Graph.new(csv_file)
