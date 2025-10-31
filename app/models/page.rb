class Page < ApplicationRecord
  has_one  :meta_tag, as: :attachable, dependent: :destroy, inverse_of: :attachable

  has_many :page_items, dependent: :destroy

  accepts_nested_attributes_for :meta_tag # , reject_if: lambda { |attributes| attributes["title"].blank? }
  accepts_nested_attributes_for :page_items

  scope :by_sort, -> (sn = "") { or_default(sn).or_name_a(sn).or_name_d(sn).or_updated_at_a(sn).or_updated_at_d(sn).or_alias_a(sn).or_alias_d(sn) }
  scope :or_default, -> (sn = "") { order("id asc") if sn.nil? || sn == "" }
  scope :or_name_a, -> (sn) { order("name asc") if sn == "order_name_asc" }
  scope :or_name_d, -> (sn) { order("name desc") if sn == "order_name_desc" }
  scope :or_updated_at_a, -> (sn) { order("updated_at asc") if sn == "order_updated_at_asc" }
  scope :or_updated_at_d, -> (sn) { order("updated_at desc") if sn == "order_updated_at_desc" }
  scope :or_alias_a, -> (sn) { order("alias asc") if sn == "order_alias_asc" }
  scope :or_alias_d, -> (sn) { order("alias desc") if sn == "order_alias_desc" }
  scope :or_meta_title_a, -> (sn) { order("meta_tag_title asc") if sn == "meta_tag_title_asc" }
  scope :or_meta_title_d, -> (sn) { order("meta_tag_title desc") if sn == "meta_tag_title_desc" }

  validates :h1, :name, presence: true

end
