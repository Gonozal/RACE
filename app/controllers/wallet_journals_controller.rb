class WalletJournalsController < ApplicationController
  # GET /wallet_journals
  # GET /wallet_journals.json
  def index
    @wallet_journals = WalletJournal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wallet_journals }
    end
  end

  # GET /wallet_journals/1
  # GET /wallet_journals/1.json
  def show
    @wallet_journal = WalletJournal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wallet_journal }
    end
  end

  # GET /wallet_journals/new
  # GET /wallet_journals/new.json
  def new
    @wallet_journal = WalletJournal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wallet_journal }
    end
  end

  # GET /wallet_journals/1/edit
  def edit
    @wallet_journal = WalletJournal.find(params[:id])
  end

  # POST /wallet_journals
  # POST /wallet_journals.json
  def create
    @wallet_journal = WalletJournal.new(params[:wallet_journal])

    respond_to do |format|
      if @wallet_journal.save
        format.html { redirect_to @wallet_journal, notice: 'Wallet journal was successfully created.' }
        format.json { render json: @wallet_journal, status: :created, location: @wallet_journal }
      else
        format.html { render action: "new" }
        format.json { render json: @wallet_journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wallet_journals/1
  # PUT /wallet_journals/1.json
  def update
    @wallet_journal = WalletJournal.find(params[:id])

    respond_to do |format|
      if @wallet_journal.update_attributes(params[:wallet_journal])
        format.html { redirect_to @wallet_journal, notice: 'Wallet journal was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @wallet_journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallet_journals/1
  # DELETE /wallet_journals/1.json
  def destroy
    @wallet_journal = WalletJournal.find(params[:id])
    @wallet_journal.destroy

    respond_to do |format|
      format.html { redirect_to wallet_journals_url }
      format.json { head :ok }
    end
  end
end
