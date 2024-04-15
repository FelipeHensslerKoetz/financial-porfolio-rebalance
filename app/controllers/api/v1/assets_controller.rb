module Api
  module V1
    class AssetsController < ApplicationController
      # TODO: paginate the results with kaminari
      def index
        @assets = Asset.global

        render json: @assets, status: :ok
      end

      def show
        @asset = Asset.global.find_by(id: params[:id])

        if @asset
          render json: @asset, status: :ok
        else
          render json: nil, status: :not_found
        end
      end

      def search
        @assets = Asset.global.where(
          'name LIKE :asset or code LIKE :asset', asset: "%#{params[:asset]}%"
        )

        render json: @assets, status: :ok
      end

      # TODO: control the jobs calls
      def deep_search
        AssetDiscoveryJob.perform_async(params[:asset])

        render json: { message: 'Asset discovery job has been scheduled' }, status: :ok
      end
    end
  end
end
