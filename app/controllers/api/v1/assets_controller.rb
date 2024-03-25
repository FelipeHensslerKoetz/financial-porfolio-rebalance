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
    end
  end
end
