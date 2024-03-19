# frozen_string_literal: true

# Currency model
class Currency < ApplicationRecord
  validates :name, :code, presence: true
end
