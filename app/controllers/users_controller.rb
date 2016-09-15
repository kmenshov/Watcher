class UsersController < ApplicationController
  #rescue_from (ActiveRecord::RecordNotFound) { |e| redirect_to users_url }

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:index, :new, :create]


  # GET /users
  # GET /users.json
  def index
    @users = User.available_users_for(current_user)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user

        default_group = ResGroup.new(name: Rails.configuration.res_group_reserved_names[0], user_id: @user.id)
        default_group.save(validate: false)

        format.html { redirect_to @user, flash: { success: 'User was successfully created.' } }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, flash: { success: 'User was successfully updated.' } }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, flash: { success: 'User was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.available_users_for(current_user).find_by_id(params[:id])
      redirect_back_or_default(default: users_url, flash: { danger: 'User not found or access denied.' }) unless @user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
