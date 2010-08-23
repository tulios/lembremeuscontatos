class Contato < ActiveRecord::Base
                  
  attr_protected :user_id
  belongs_to :user
  
  validates_presence_of :nome, :email
  validates_uniqueness_of :email
  
end
