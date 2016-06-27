class GoogleAccountsController < ApplicationController
  before_action :set_google_account, only: [:show, :edit, :update, :destroy]

  # GET /google_accounts
  # GET /google_accounts.json
  def index
    @google_accounts = GoogleAccount.all
  end

  # GET /google_accounts/1
  # GET /google_accounts/1.json
  def show
  end

  # GET /google_accounts/new
  def new
    @google_account = GoogleAccount.new
  end

  # GET /google_accounts/1/edit
  def edit
  end

  # POST /google_accounts
  # POST /google_accounts.json
  def create
    @google_account = GoogleAccount.new(google_account_params)

    respond_to do |format|
      if @google_account.save
        format.html { redirect_to @google_account, notice: 'Google account was successfully created.' }
        format.json { render :show, status: :created, location: @google_account }
      else
        format.html { render :new }
        format.json { render json: @google_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /google_accounts/1
  # PATCH/PUT /google_accounts/1.json
  def update
    respond_to do |format|
      if @google_account.update(google_account_params)
        format.html { redirect_to @google_account, notice: 'Google account was successfully updated.' }
        format.json { render :show, status: :ok, location: @google_account }
      else
        format.html { render :edit }
        format.json { render json: @google_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /google_accounts/1
  # DELETE /google_accounts/1.json
  def destroy
    @google_account.destroy
    respond_to do |format|
      format.html { redirect_to google_accounts_url, notice: 'Google account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_google_account
      @google_account = GoogleAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def google_account_params
      params.require(:google_account).permit(:user_id, :access_token, :refresh_token, :expires_at, :gmail)
    end
end
