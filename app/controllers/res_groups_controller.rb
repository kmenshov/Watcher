class ResGroupsController < ApplicationController
  rescue_from ActiveRecord::ReadOnlyRecord, with: :read_only_record
  rescue_from (ActiveRecord::RecordNotFound) { |e| redirect_to res_groups_url }

  before_action :set_res_group, only: [:show, :edit, :update, :destroy]

  # GET /res_groups
  # GET /res_groups.json
  def index
    @res_groups = ResGroup.all
  end

  # GET /res_groups/1
  # GET /res_groups/1.json
  def show
  end

  # GET /res_groups/new
  def new
    @res_group = ResGroup.new
  end

  # GET /res_groups/1/edit
  def edit
    read_only_record if @res_group.readonly?
  end

  # POST /res_groups
  # POST /res_groups.json
  def create
    @res_group = ResGroup.new(res_group_params)

    respond_to do |format|
      if @res_group.save
        format.html { redirect_to @res_group, notice: 'Res group was successfully created.' }
        format.json { render :show, status: :created, location: @res_group }
      else
        format.html { render :new }
        format.json { render json: @res_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /res_groups/1
  # PATCH/PUT /res_groups/1.json
  def update
    respond_to do |format|
      if @res_group.update(res_group_params)
        format.html { redirect_to @res_group, notice: 'Res group was successfully updated.' }
        format.json { render :show, status: :ok, location: @res_group }
      else
        format.html { render :edit }
        format.json { render json: @res_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /res_groups/1
  # DELETE /res_groups/1.json
  def destroy
    @res_group.destroy
    respond_to do |format|
      format.html { redirect_to res_groups_url, notice: 'Res group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_res_group
      @res_group = ResGroup.find(params[:id])
      @res_group.readonly! if Rails.configuration.res_group_reserved_names.include?(@res_group.name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def res_group_params
      params.require(:res_group).permit(:name)
    end

    def read_only_record
      respond_to do |format|
        format.html { redirect_to res_groups_url, notice: 'This group can not be modified.' }
        #format.json { render json: @res_group.errors, status: :unprocessable_entity }
      end
    end
end
