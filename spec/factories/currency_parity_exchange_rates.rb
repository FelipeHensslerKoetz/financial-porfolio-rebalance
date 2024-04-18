FactoryBot.define do
  factory :currency_parity_exchange_rate do
    currency_parity { create(:currency_parity) }
    exchange_rate { 5.0 }
    last_sync_at { Time.zone.now }
    reference_date { Time.zone.now }

    trait :updated do
      status { 'updated' }
    end

    trait :scheduled do
      status { 'scheduled' }
    end

    trait :processing do
      status { 'processing' }
    end

    trait :outdated do
      status { 'outdated' }
    end

    trait :failed do
      status { 'failed' }
    end

    trait :with_hg_brasil_stock_price_partner_resource do
      partner_resource do
        create(:partner_resource, :hg_brasil_stock_price) unless PartnerResource.exists?(name: 'HG Brasil - Stock Price')
        PartnerResource.find_by(name: 'HG Brasil - Stock Price')
      end
    end

    trait :with_alpha_vantage_global_quote_partner_resource do
      partner_resource do
        create(:partner_resource, :alpha_vantage_global_quote) unless PartnerResource.exists?(name: 'Alpha Vantage - Global Quote')
        PartnerResource.find_by(name: 'Alpha Vantage - Global Quote')
      end
    end

    trait :with_alpha_vantage_currency_exchange_rate_partner_resource do
      partner_resource do
        unless PartnerResource.exists?(name: 'Alpha Vantage - Currency Exchange Rate')
          create(:partner_resource,
                 :alpha_vantage_currency_exchange_rate)
        end
        PartnerResource.find_by(name: 'Alpha Vantage - Currency Exchange Rate')
      end
    end

    trait :with_alpha_vantage_symbol_search_partner_resource do
      partner_resource do
        create(:partner_resource, :alpha_vantage_symbol_search) unless PartnerResource.exists?(name: 'Alpha Vantage - Symbol Search')
        PartnerResource.find_by(name: 'Alpha Vantage - Symbol Search')
      end
    end
  end
end
