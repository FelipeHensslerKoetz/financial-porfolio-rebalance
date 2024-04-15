# frozen_string_literal: true

# Asset model
class Asset < ApplicationRecord
  belongs_to :user, class_name: 'User', inverse_of: :assets, optional: true
  has_many :asset_price_trackers, dependent: :destroy

  validates :name, :business_name, :code, presence: true
  validates :code, uniqueness: true
  validates :custom, inclusion: { in: [true, false] }

  scope :global, -> { where(user: nil, custom: false) }
  scope :custom, -> { where(custom: true) }
  scope :by_user, ->(user) { where(user:) }

  def up_to_date?
    asset_price_trackers.up_to_date.any?
  end
end
