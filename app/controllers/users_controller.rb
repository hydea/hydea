class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_is_admin, except: [:show]
  before_action :ensure_that_signed_in, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @id = @user.id
    @userHistories = User.find(@id).histories.where(basket: "New")
    if @id == current_user.id or current_user.moderator?
      @ideas = @userHistories.map{|usr| usr.idea}
    else
      @ideas = Array.new
      @userHistories.each do |usr|
        if !(usr.idea.histories.all.last.basket == 'New' or usr.idea.histories.all.last.basket == 'Rejected')
          @ideas.push(usr.idea)
        end
      end
    end
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
        format.html { redirect_to @user, notice: (t :user) + " " + (t :create) }
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
        format.html { redirect_to @user, notice: (t :user) + " " + (t :update) }
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
    if current_user.admin
      @user.destroy
      respond_to do |format|
      format.html { redirect_to users_url, notice: (t :user) + " " + (t :destroy) }
      format.json { head :no_content }
    end
    else
      redirect_to users_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:admin, :moderator, :banned, :persistent_id, :name, :email, :title)
    end
end
