# frozen_string_literal: true

# Description: This file contains the data origin model.
class DataOrigin < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
end
