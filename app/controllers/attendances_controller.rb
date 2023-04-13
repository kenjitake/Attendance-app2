class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month
  before_action :admin_or_correct_user, only: [:edit_one_month, :update_one_month]
  
  
  UPDATE_ERROR_MESSAGES= "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @user= User.find(params[:user_id])
    @attendance= Attendance.find(params[:id])
    
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0).floor_to(15.minutes))
        flash[:info]= "おはようございます"
      else
        flash[:danger]= UPDATE_ERROR_MESSAGES
      end
    else @attendance.started_at.present? && @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0).floor_to(15.minutes))
        flash[:info]= "お疲れ様でした"
      else
        flash[:danger]= UPDATE_ERROR_MESSAGES
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      attendance_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
        attendance.save!(context: :item)
      end
    end
    flash[:success]= "勤怠情報を編集しました"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger]= "無効な入力があった為、更新をキャンセルしました"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  
  private
   
   
    def attendance_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :overtime_instraction, :instractor])[:attendances]
    end
    
    
end
