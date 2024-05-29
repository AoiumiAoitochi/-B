class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if item[:started_at].blank? && item[:finished_at].present?
          flash[:danger] = "出社時間を入力してください！"
          redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
        elsif item[:started_at].present? &&  item[:finished_at].blank?
          flash[:danger] = "出社のみの更新ができません!"
          redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
        elsif item[:started_at].present? &&  item[:finished_at].present?
          if item[:finished_at] < item[:started_at]
            flash[:danger] = "退社時間の見直しをしてください!"
            redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
          else
            attendance.update!(item)
          end
        end
      end
      flash[:success] = "勤怠情報を更新しました!"
      redirect_to user_url(date: params[:date])
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあります!確認してください!"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
    end
  end

  private

  def attendances_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :overtime_instruction, :supervisor])[:attendances]
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end
  end

  def set_one_month
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "正しいユーザー情報が取得できませんでした。"
    redirect_to root_url
  end
end
