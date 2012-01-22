class WalletTransactionsController < ApplicationController
  # GET /market_transactions
  # GET /market_transactions.json
  def index
    WalletTransaction.api_update_own(owner: current_user)
  end
end
