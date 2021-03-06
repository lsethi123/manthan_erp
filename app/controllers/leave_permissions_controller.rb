class LeavePermissionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def get_date
    @jsondata = LeavePermission.get_leaves(current_user, params[:dates])
    respond_to do |format|
      format.json do
        render :json => @jsondata
      end
    end
  end
  
  
  def index
    @leave_permission = LeavePermission.new
  end
  
  def approval
  end

  def approval_status
    @leave_permissions = LeavePermission.get_details(current_user)
    respond_to do |format|
      format.json do
        render :json => @leave_permissions
      end
      format.html do
        render "approval_status"
      end
    end
    p @leave_permissions
  end
  def count_no
    hash = FacultyAttendance.get_faculty_details(current_user.faculty_master, params[:type_of_leave])
    respond_to do |format|
      format.json do
        render :json => hash
      end
    end
  end

  
  def create
    @leave_permission = LeavePermission.new(permission_params)
    @leave_permission.type_of_leave = LeavePermission.get_type_of_leave(current_user)
    @leave_permission.casual_leave_count = LeavePermission.get_casual_leave_count(current_user)
    @leave_permission.sick_leave_count = LeavePermission.get_sick_leave_count(current_user)
    @leave_permission.faculty_master_id = LeavePermission.get_faculty_attendance_id(current_user)
    #@leave_permission.bal_leave = LeavePermission.get_leaves(current_user, params[:dates])

    respond_to do |format|
      if @leave_permission.save 
        format.html { redirect_to approval_status_leave_permissions_path, notice: 'Leave Form was successfully created.' }
      else
        format.html { render action: 'index' }
      end
    end
  end
  

  def get_holidays
    values = LeavePermission.get_leaves
    respond_to do |format|
      format.json do
        render :json => values
        end
    end
  end


  def permission_params
    params.require(:leave_permission).permit(:from_day, :to_day, :from_date, :to_date, :reason, :type_of_leave, :status, :bal_leave, :casual_leave_count, :sick_leave_count, :faculty_attendance_id, :dates)
    
  end

  
end
