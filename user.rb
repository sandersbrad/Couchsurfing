require 'neo4j'

class User
  include Neo4j::ActiveNode
  validates :user_id, presence: true, null: false

  property :user_id, constraint: :unique
end
