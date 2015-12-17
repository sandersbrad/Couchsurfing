require 'neo4j'
require_relative 'user'

class Relationship
  include Neo4j::ActiveRel

  from_class User
  to_class User
  type 'relationship'
end
