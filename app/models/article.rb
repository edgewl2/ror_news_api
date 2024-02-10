class Article < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  belongs_to :source
end
