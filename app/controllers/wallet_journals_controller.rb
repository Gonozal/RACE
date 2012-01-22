class WalletJournalsController < ApplicationController
  # GET /wallet_journals
  # GET /wallet_journals.json
  def index
    @wallet_journals = WalletJournal.all
    WalletJournal.api_update_own(owner: current_user)
  end
end

