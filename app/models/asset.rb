class Asset < ApplicationRecord
  belongs_to :user, class_name: 'User', inverse_of: :assets, optional: true
  has_many :asset_prices, dependent: :destroy

  validates :name, :business_name, :code, presence: true
  validates :code, uniqueness: true
  validates :custom, inclusion: { in: [true, false] }

  scope :global, -> { where(user: nil, custom: false) }
  scope :custom, -> { where(custom: true) }
  scope :by_user, ->(user) { where(user:) }

  def up_to_date?
    asset_prices.up_to_date.any?
  end

  def latest_asset_price
    return unless up_to_date?

    asset_prices.up_to_date.order(reference_date: :desc).first
  end
end
