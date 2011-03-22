class Category < ActiveRecord::Base
  has_many :leagues
  has_many :questions

  validates :status, :inclusion => {:in => ['active', 'coming_soon']}
  
  def dom_name
    name.downcase.split(/\s+/).join("_")
  end
  
  def available?
    self.status == "active"
  end
end
