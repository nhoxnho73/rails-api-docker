class Genre < ApplicationRecord
  has_many :movies
  
  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :id, :name
    end
  end
end
