class MetaTag < ApplicationRecord
  belongs_to :attachable, polymorphic: true, inverse_of: :meta_tag
end
