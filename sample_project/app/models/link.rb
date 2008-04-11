class Link < ActiveRecord::Base
  acts_as_list
  belongs_to :article
  attr_protected :user_id
  
  validates_presence_of :url
end
