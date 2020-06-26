class ScenariosController < ApplicationController
  before_action :user_is_admin, only: [:new, :edit, :update, :destroy, :import]
  before_action :set_scenario, only: [:show, :edit, :update, :destroy, :translate, :locations, :import, :export]

  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.all
  end

  # GET /scenarios/1
  # GET /scenarios/1.json
  def show
  end

  # GET /scenarios/new
  def new
    @scenario = Scenario.new
  end

  # GET /scenarios/1/edit
  def edit
  end

  # POST /scenarios
  # POST /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params)

    respond_to do |format|
      if @scenario.save
        format.html { redirect_to @scenario, notice: 'Scenario was successfully created.' }
        format.json { render :show, status: :created, location: @scenario }
      else
        format.html { render :new }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    respond_to do |format|
      if @scenario.update(scenario_params)
        format.html { redirect_to @scenario, notice: 'Scenario was successfully updated.' }
        format.json { render :show, status: :ok, location: @scenario }
      else
        format.html { render :edit }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.json
  def destroy
    @scenario.destroy
    respond_to do |format|
      format.html { redirect_to scenarios_url, notice: 'Scenario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Shows transtation page
  def translate
    @lines = Line.where(fragment: @scenario.fragments).order(:id).page params[:page]
  end

  # Shows locations transtation page
  def locations
    @locations = Location.where(fragment: @scenario.fragments).order(:id).page params[:page]
  end

  # Import from the binary file
  def import
    @scenario.import
    respond_to do |format|
      format.html { redirect_to scenarios_url, notice: 'Scenario was successfully imported.' }
      format.json { head :no_content }
    end
  end

  # Export to the binary file
  def export
    @scenario.export
    send_file "#{@scenario.bin_file_name}.new", type: 'application/octet-stream'
  end

  # Allows to download a specific game build
  def build
    date = params[:date][/\d{8}/] or not_found
    filename = "7scarlet-rus-build#{date}.zip"
    full_path = Rails.root.join 'data', filename
    send_file full_path, type: 'application/zip', filename: filename
    headers['Content-Length'] = File.size full_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scenario
      @scenario = Scenario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scenario_params
      params.require(:scenario).permit(:name, :filename, :lines, :translated)
    end

    # Checks id the user is admin
    def user_is_admin
      unless current_user.admin?
      flash[:notice] = "You may only view existing scenarios."
      redirect_to root_path
      end
    end
end
