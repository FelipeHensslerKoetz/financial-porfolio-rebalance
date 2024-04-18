class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :assets, class_name: 'Asset', inverse_of: :user, dependent: :restrict_with_error
  has_many :investment_portfolios, class_name: 'InvestmentPortfolio',
                                   inverse_of: :user, dependent: :restrict_with_error
  has_many :rebalance_orders, class_name: 'RebalanceOrder', inverse_of: :user,
                              dependent: :restrict_with_error
end
