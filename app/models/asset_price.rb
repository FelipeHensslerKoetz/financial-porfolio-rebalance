# TODO: rename model to AssetPrices
class AssetPrice < ApplicationRecord
  include AASM

  belongs_to :asset
  belongs_to :data_origin
  belongs_to :currency

  validates :price, :last_sync_at, :reference_date, presence: true

  scope :up_to_date, -> { where(status: 'up_to_date') }
  scope :outdated, -> { where(status: 'outdated') }
  scope :processing, -> { where(status: 'processing') }
  scope :error, -> { where(status: 'error') }

  aasm column: :status do
    state :up_to_date, initial: true
    state :outdated
    state :processing
    state :error

    event :outdate do
      transitions from: :up_to_date, to: :outdated
    end

    event :process do
      transitions from: :outdated, to: :processing
    end

    event :fail do
      transitions from: :processing, to: :error
    end

    event :success do
      transitions from: :processing, to: :up_to_date
    end

    event :reprocess do
      transitions from: :error, to: :processing
    end
  end
end
