class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update, ]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info,:index]
  before_action :set_one_month, only: :show

  def index
    @users = if params[:search].present?
      @search_word = params[:search]
      User.where("name LIKE ?", "%#{@search_word}%").paginate(page: params[:page])
    else
      @search_word = nil
      User.paginate(page: params[:page])
    end
  end



  def show
    @user = User.find(params[:id])
    if current_user.admin? || current_user?(@user)
      @worked_sum = @attendances.where(user_id: @user.id).where.not(started_at: nil).count
    else
      flash[:danger] = "他のユーザーの情報にアクセスする権限がありません。"
      redirect_to root_url
    end
  end



  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      flash.now[:danger] = @user.errors.full_messages.join(", ")
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash_messages") }
      end
    end
  end


  def edit
  end


  def update
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      flash.now[:danger] = @user.errors.full_messages.join(", ")
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash_messages") }
      end
    end
  end


  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_all
    # 一括編集の処理を実装
  end

  def update_all
    users = User.all
      new_basic_time = params[:basic_time]
      new_work_time = params[:work_time]
      success = true

      users.each do |user|
        if !user.update(basic_time: new_basic_time, work_time: new_work_time)
          success = false
          break
        end
    end

    if success
      flash.now[:success] = "全ユーザーの基本情報が更新されました。"
    else
      flash.now[:danger] = "更新は失敗しました。"
    end
      redirect_to users_path
  end


  def edit_basic_info
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render partial: 'users/edit_basic_info', locals: { user: @user } } # 修正
      format.turbo_stream
    end
  end




  def update_basic_info
    if @user.update(basic_info_params)
      flash.now[:success] = "#{@user.name}の基本情報を更新しました!"
    else
      flash.now[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end

    respond_to do |format|
      format.html { redirect_to users_url }
      format.turbo_stream
    end
  end

  private

  def admin_user
    unless current_user.admin?
      flash[:danger] = "管理者のみがアクセスできます。"
      redirect_to(root_url)
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end

  def basic_info_params
    params.require(:user).permit(:name, :email, :department, :basic_time, :work_time)
  end
end
