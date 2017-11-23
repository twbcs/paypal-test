class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.all
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales
  # POST /sales.json
  def create
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def mpg
    @client_options = client.options
    @params = client.generate_mpg_params({
      MerchantOrderNo: SecureRandom.hex(4),
      Amt: 200,
      ItemDesc: '一般交易測試',
      Email: 'hello@localhost.com',
      EmailModify: 0,
      LoginType: 0,
      CREDIT: 1
    })
  end

  def period


    @client_options = client.options
    @params = client.generate_credit_card_period_params({
      MerchantOrderNo: SecureRandom.hex(4),
      ProdDesc: '定期定額交易測試',
      PeriodAmt: 100,
      PeriodAmtMode: 'Total',
      PeriodType: 'M',
      PeriodPoint: '01',
      PeriodStartType: 1,
      PeriodTimes: '5',
      Email: 'hello@localhost.com'
    })
    cipher = OpenSSL::Cipher::AES128.new(:CBC)
    cipher.encrypt
    cipher.key = 'TKbNDvxRvR2YH0R3FYviAhY4RqndPb4I'
    cipher.iv = 'WfwzL3rgVtfDu6G9'
    encrypted = cipher.update(@params.to_s) + cipher.final
    
    @encrypt_params = Base64.encode64(encrypted)
  end

  def validate
    client.verify_check_code(request.POST).to_s
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:name)
    end

    def client
      Spgateway::Client.new({
        merchant_id: 'MS32129014',
        hash_key: 'TKbNDvxRvR2YH0R3FYviAhY4RqndPb4I',
        hash_iv: 'WfwzL3rgVtfDu6G9',
        mode: :test
      })
    end
end
