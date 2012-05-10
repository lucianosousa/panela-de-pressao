class Organization < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :owner, :class_name => "User"

  attr_accessible :name
end
