class StudentMastersController < ApplicationController
  load_resource :only => [:show, :monthly_pdcs, :next_term_fee, :annual_discount_details, :dashboard, :update_address, :attendance_calendar_for_month, :student_summarized_monthly_report, :transport_details, :change_transport]
  
  def index
    page = params[:page].present? ? params[:page] : 1
    if current_user.admin?
      if params[:student_id].present?
        @student_masters = StudentMaster.where(:id => params[:student_id]).paginate(:page => page)
      else
        @student_masters = StudentMaster.all.order("name").paginate(:page => page)
      end
    elsif current_user.parent?
      @student_masters = current_user.parent.students
    end
  end
  
  def show
    respond_to do |format|
      format.json do
        render :json => {:id => @student_master.id, :name => @student_master.name , :joining_date => @student_master.joining_date, :grade => @student_master.grade, :section => @student_master.section, :academic_year => session[:academic_year], :dob => @student_master.dob}
      end
      format.html do
        render "show"
      end
    end
  end

  def monthly_pdcs
    payment_master = @student_master.parent_payment_master
    respond_to do |format|
      format.json do
        monthly_pdcs = []
        s_f_c = StudentFeeCalculator.new(@student_master)
        if payment_master.present?
          monthly_pdcs = []
        else
          monthly_pdcs = MonthlyPdcAmount.belongs_to_fee_grade_bucket(@student_master.grade_bucket_id).map do |pdc_amount|
            {:post_dated_cheque_id => pdc_amount.post_dated_cheque_id, :month => pdc_amount.post_dated_cheque.date, :amount_in_rupees => s_f_c.applicable_month_fee(pdc_amount), :cheque_number => nil, :clearence_date => nil }
          end
        end
        render :json => monthly_pdcs
      end
    end
  end
  
  def next_term_fee
    payment_master = @student_master.parent_payment_master
    respond_to do |format|
      format.json do
        s_f_c = StudentFeeCalculator.new(@student_master)
        term = nil
        unless payment_master.present?
          term = TermWiseGradeFee.belongs_to_fee_grade_bucket(@student_master.grade_bucket_id).order("term_definition_id").first
        else
          term = payment_master.next_term_fee 
        end
        amount = s_f_c.applicable_term_fee(term)
        render :json => {:term_definition_id => term.term_definition_id, :amount_in_rupees => amount, :term => term.term_definition.term_definition, :term_date => term.term_definition.termdate }
      end
    end  
  end

  def annual_discount_details
    respond_to do |format|
      format.json do
        render :json => DiscountCalculator.new(@student_master).get_discount()
      end
    end
  end

  def belongs_to_parent
    @parent = ParentMaster.find(params[:parent_id])
    respond_to do |format|
      format.json do
        render :json => StudentMastersDecorator.decorate_collection(@parent.students)
      end
    end
  end

  def new_upload
    @student_master_uploader = StudentMasterUploader.new
    respond_to do |format|
      format.html { render "new_upload"}
      format.xls { send_data @student_master_uploader.xls_template(col_sep: "\t") }
    end
  end


  def upload
    @student_master_uploader = StudentMasterUploader.new(params[:student_master_uploader])
    if @student_master_uploader.save
      flash[:success] = I18n.t :success, :scope => [:student_master, :upload]
      redirect_to student_masters_path
    else
      render "new_upload"
    end
  end
  
  def dashboard
  end

  def update_address
    respond_to do |format|
      format.json do
        render :json => @student_master.update(JSON.parse(params[:address]))
      end
    end
  end

  def attendance_calendar_for_month
    respond_to do |format|
      format.json do
        render :json => StudentReport::Attendence.new(@student_master).month_report_for_full_calendar(params[:month])
      end
    end
  end

  def student_summarized_monthly_report
    respond_to do |format|
      format.json do
        render :json => StudentReport::Attendence.new(@student_master).student_summarized_monthly_report
      end
    end
  end

  def transport_details
    respond_to do |format|
      format.json do
        if @student_master.bus_facility?
          @student_route = @student_master.student_route_mapping
          data = { }
          if @student_route.present?
            data = {student_route_id: @student_route.id, location: @student_route.location_master.location_name, route_id: @student_route.route.id, route_no: @student_route.route.route_no, start_location: @student_route.route.start_location_name, end_location: @student_route.route.end_location_name}
           end
          render :json => data 
        else
          render :json => false
        end
      end
    end
  end
  
  def change_transport
    respond_to do |format|
      format.json do
        if @student_master.student_route_mapping.destroy
          ApprovalMailer.approve_student_route_change(LocationMaster.find(params[:new_location_id]), @student_master).deliver
          render :json => true
        else
          render :json => false
        end
      end
    end
  end
end
