module Api
  module V1
    class AssetsController < ApplicationController
      # List all global assets - paginate results
      def index
        @assets = Asset.global

        render json: @assets
      end

      # Show a specific global asset
      def show
        @asset = Asset.global.find_by(id: params[:id])

        if @asset
          render json: @asset
        else
          render json: nil, status: :not_found
        end
      end

      # Search for a specific global asset (name or identifier) - search bar
      def search
        @assets = Asset.global.where(
          'name LIKE :asset or code LIKE :asset', asset: "%#{params[:asset]}%"
        )

        render json: @assets
      end

      # deep search for a specific global asset (name or identifier) - searchbar
      def deep_search
        @assets = Assets::Discovery.new(asset: params[:asset]).call

        render json: @assets
      end
    end
  end
end
