class UsersController < ApplicationController
  
  before_action :set_user, only:[:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only:[:show, :index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: [:show]
  before_action :set_one_month, only: :show
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  
  def new 
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success]="ユーザーを作成しました"
      redirect_to @user
    else
      render :new
    end  
  end
  
  
  def index
    
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = User.ransack(search_params, activated_true: true)
      @title = "検索結果"
    else
      @q = User.ransack(activated_true: true)
      @title = "全てのユーザー"
    end
    @users = @q.result.paginate(page: params[:page])
  end
  
  def edit
    
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success]= "ユーザー情報を更新しました"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success]= "#{@user.name}のデータを削除しました"
    redirect_to users_url
  end
  
  def edit_basic_info

  end
  
  def update_basic_info
    @users= User.all
    if @users.update(basic_info_params)
      flash[:success]= "基本情報を更新しました"
    else
      flash[:danger]= "基本情報の更新に失敗しました。"
    end
      redirect_to users_url
  end
  
  
  private
  
    
    def user_params 
      params.require(:user).permit(:name,:email,:department,:password,:password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time,:work_time)
    end
    
    
    def search_params
      params.require(:q).permit(:name_cont)
    end
    
    
    
    
end
