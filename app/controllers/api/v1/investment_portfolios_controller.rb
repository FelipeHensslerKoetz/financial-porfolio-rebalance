module Api
  module V1
    class InvestmentPortfoliosController < ApplicationController
      before_action :set_investment_portfolio, only: %i[show update destroy]

      # All investment portfolios of a given user
      def index
        @investment_portfolios = current_user.investment_portfolios

        render json: @investment_portfolios, include: %i[investment_portfolio_assets user currency], status: :ok
      end

      # A single investment portfolio of a given user
      def show
        render json: @investment_portfolio, include: %i[investment_portfolio_assets user currency], status: :ok
      end

      # Create a new investment portfolio
      def create
        @investment_portfolio = InvestmentPortfolio.new(investment_portfolio_params.merge(user: current_user))

        if @investment_portfolio.save
          render json: @investment_portfolio, include: %i[investment_portfolio_assets user currency], status: :created
        else
          render json: { errors: @investment_portfolio.errors.messages }, status: :unprocessable_entity
        end
      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def update
        if @investment_portfolio.update(investment_portfolio_params)
          render json: @investment_portfolio, include: %i[investment_portfolio_assets user currency], status: :ok
        else
          render json: { errors: @investment_portfolio.errors.messages }, status: :unprocessable_entity
        end
      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def destroy
        if @investment_portfolio.destroy
          head :no_content
        else
          render json: { errors: @investment_portfolio.errors.messages }, status: :unprocessable_entity
        end
      end

      private

      def set_investment_portfolio
        @investment_portfolio = current_user.investment_portfolios.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'InvestmentPortfolio not found' }, status: :not_found
      end

      def investment_portfolio_params
        params.require(:investment_portfolio).permit(:name, :description, :currency_id,
                                                     investment_portfolio_assets_attributes: %i[id asset_id quantity allocation_weight _destroy])
      end
    end
  end
end
