class PageItemElement < ApplicationRecord
  belongs_to :page_item

  validates :name, presence: true
end
