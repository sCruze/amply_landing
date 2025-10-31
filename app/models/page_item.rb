class PageItem < ApplicationRecord
  belongs_to :page, inverse_of: :page_items

  has_many :page_item_elements, dependent: :destroy

  accepts_nested_attributes_for :page_item_elements, reject_if: proc { |attributes| attributes['name'].blank? }

  scope :by_sort, -> (sn = "") { or_default(sn).or_name_a(sn).or_name_d(sn).or_updated_at_a(sn).or_updated_at_d(sn).or_alias_a(sn).or_alias_d(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn.nil? || sn == "" }
  scope :or_name_a, -> (sn) { order("name asc") if sn == "order_name_asc" }
  scope :or_name_d, -> (sn) { order("name desc") if sn == "order_name_desc" }
  scope :or_updated_at_a, -> (sn) { order("updated_at asc") if sn == "order_updated_at_asc" }
  scope :or_updated_at_d, -> (sn) { order("updated_at desc") if sn == "order_updated_at_desc" }
  scope :or_alias_a, -> (sn) { order("alias asc") if sn == "order_alias_asc" }
  scope :or_alias_d, -> (sn) { order("alias desc") if sn == "order_alias_desc" }
end
