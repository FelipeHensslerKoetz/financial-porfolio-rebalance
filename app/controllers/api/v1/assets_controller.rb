module Api
  module V1
    class AssetsController < ApplicationController
      def index
        @assets = Asset.global

        render json: @assets
      end

      def show
        @asset = Asset.global.find_by(id: params[:id])

        if @asset
          render json: @asset
        else
          render json: nil, status: :not_found
        end
      end

      def search
        @assets = Asset.global.where(
          'name LIKE :asset or identifier LIKE :asset', asset: "%#{params[:asset]}%"
        )

        render json: @assets
      end
    end
  end
end
