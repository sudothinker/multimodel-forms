class Article < ActiveRecord::Base
  has_many_with_attributes :links, {:include => :user_id}, :order => 'position ASC'
end
