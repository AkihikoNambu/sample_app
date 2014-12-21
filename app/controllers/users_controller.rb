class UsersController < ApplicationController
  #デフォルトではbefore_actionが全てのアクションに適用される。
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
  	@user = User.new
  end

  def index
  	# @users = User.all

  	@users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
   @user = User.new(user_params)    # 実装は終わっていないことに注意!
	if @user.save
	  sign_in @user
	  flash[:success] = "Welcome to the Sample App!"
	  redirect_to @user
	else
     render 'new'
	end
  end

  def edit
  	# beforeアクションで以下のコードを実行済み
    # @user = User.find(params[:id])
  end

  def update
  	# beforeアクションで以下を実行済み
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
  	#ストロングパラメータ
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before actions
    # sessions helperに移動
    # def signed_in_user
    #   unless signed_in?
    #     store_location
    #   redirect_to signin_url, notice: "Please sign in." unless signed_in?
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
   
end