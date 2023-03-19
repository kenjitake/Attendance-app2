class AttendancesController < ApplicationController
  before_action :set_user, only: :edit_one_month
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month
  
  
  UPDATE_ERROR_MESSAGES= "勤怠登録に失敗しましt。やり直してください。"
  
  def update
    @user= User.find(params[:user_id])
    @attendance= Attendance.find(params[:id])
    
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info]= "おはようございます"
      else
        flash[:danger]= UPDATE_ERROR_MESSAGES
      end
    else @attendance.started_at.present? && @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info]= "お疲れ様でした"
      else
        flash[:danger]= UPDATE_ERROR_MESSAGES
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
end
