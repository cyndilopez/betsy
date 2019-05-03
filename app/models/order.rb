class Order < ApplicationRecord
  has_many :order_items, inverse_of: :order
  
  validates :status, presence: true
  
  before_create :set_status
  
  
  def total
    
  end
  
  private
  
    def set_status
      self.status = "pending"
    end
  
end
