class TeachingPlansController < ApplicationController
  def index
  # @teaching_plans = TeachingPlan.all
   # page = params[:page].present? ? params[:page] : 1
   # if params[:search].present?
     # @teaching_plans = TeachingPlan.search(params[:search]).paginate(:page => 1, :per_page => 5)
   # else
    #  @teaching_plans1 = TeachingPlan.paginate(:page => page, :per_page => 2)
end
  def calendardata   
    @teaching_plans = TeachingPlan.first
    respond_to do |format|
      format.json do
        c =User.find(current_user)       
        calendar_date = TeachingPlan.select(:teaching_date).where("trim(to_char(teaching_date, 'Month')) = '#{params[:month]}'").distinct        
        calendar_date = calendar_date.map do |teach|
          {start: teach.teaching_date, title: "Plan", description: "Plan", url: "#", teaching_date: teach.teaching_date}
        end
        p calendar_date
        p "++++++++++++++++++++++"
        render :json => calendar_date
      end
    end
  end   

  
  def new
    @teaching_plan = TeachingPlan.new
  end
  def edit
    @teaching_plan = TeachingPlan.find(params[:id])
  end
  def update
    @teaching_plan = TeachingPlan.find(params[:id])
    if @teaching_plan.update(teachingplan_params)
      flash[:success] = I18n.t :success, :scope => [:teachingplan, :update]
      redirect_to teaching_plans_path
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:teachingplan, :update]
      render "edit"
    end
  end
  def show
    @teaching_plan = TeachingPlan.find(params[:id])
  end
  
  def create
    @teaching_plan = TeachingPlan.new(teachingplan_params)
    respond_to do |format|
      
      if @teaching_plan.save
        format.html { redirect_to @teaching_plan, notice: 'Plan was successfully created.' }
        format.json { render action: 'show', status: :created, location: @teaching_plan }
      else
        format.html { render action: 'new' }
        format.json { render json: @teaching_plan.errors, status: :unprocessable_entity }
      end
    end
  end
  def teachingplan_params
    params.require(:teaching_plan).permit(:grade_master_id, :section_master_id,:teaching_date,:plan_month,:faculty_master_id,:subject_master_id )
  end
  def getfacultyidservice   
    respond_to do |format|
      format.json do
        c =User.find(current_user)       
        faculty = FacultyMaster.where('user_id = '+"#{c.id}")        
        faculty = faculty.map do |fac|
          {id: fac.id}
        end       
        render :json => faculty
      end
    end
  end
  def getgradessectionsservice    
    faculty_id = params[:_faculty_id].to_i
    respond_to do |format|
      format.json do
        mappings = TeacherGradeMapping.where('faculty_master_id='+"#{faculty_id}")     
        mappings = mappings.map do |mapping|          
          {:grade_master_id => mapping.grade_master_id, :grade_name => mapping.grade_master.grade_name,:section_master_id => mapping.section_master_id, :section_name => mapping.section_master.section_name}
          
        end
        
        render :json => mappings
        # end 
      end     
    end
  end
  def get_grade_section_subject_service    
    faculty_id = params[:_faculty_id].to_i
    respond_to do |format|
      format.json do
        mappings = TeacherGradeMapping.where('faculty_master_id='+"#{faculty_id}")     
        mappings = mappings.map do |mapping|          
          {:id => faculty_id, :grade_master_id => mapping.grade_master_id, :grade_name => mapping.grade_master.grade_name,:section_master_id => mapping.section_master_id, :section_name => mapping.section_master.section_name, :subject_master_id => mapping.subject_master_id, :subject_name => mapping.subject_master.subject_name, :grade_section_subject => (mapping.grade_master.grade_name+"- "+mapping.section_master.section_name+"- "+mapping.subject_master.subject_name)}
          
        end
        p mappings
        p "=======>"
        
        render :json => mappings
        # end 
      end     
    end
  end
  def destroy
    @teaching_plan = TeachingPlan.find(params[:id])    
    respond_to do |format|
      format.json do
        render :json => @teaching_plan.destroy
      end
      format.html do
        if @teaching_plan.destroy
          flash[:success] = I18n.t :success, :scope => [:teaching_plan ,:destroy]
        else
          flash.now[:fail] = I18n.t :fail, :scope => [:teaching_plan, :destroy]
        end
        redirect_to teaching_plans_path
      end
    end
  end
  def teaching_date
    respond_to do |format|
      format.json do
        c =User.find(current_user)       
        teachingdate = TeachingPlan.where("teaching_date = '#{params[:date]}'")        
        teachingdate = teachingdate.map do |teach|
          {id: teach.id, plan_month: teach.plan_month}
        end
        p teachingdate
        p "********************"
        render :json => teachingdate
      end
    end
  end
  def getmonthlycalendarservice
   # @teaching_plans = @teaching_plans1.group_by { |t| t.teaching_date.beginning_of_month }
    respond_to do |format|
      format.json do
        c =User.find(current_user)       
        calendar_date = TeachingPlan.select("to_char(teaching_date, 'Month') as month, to_char(teaching_date, 'mm') as month_number, to_char(teaching_date, 'yyyy') as year").distinct        
        calendar_date = calendar_date.map do |teach|
          {month: teach.month, month_number: teach.month_number.to_i-1, year: teach.year}
        end
        sorted_dates = calendar_date.sort{|d1, d2| Date.new(d1[:year].to_i, d1[:month_number].to_i, 1) <=> Date.new(d2[:year].to_i, d2[:month_number].to_i, 1) }
        render :json => sorted_dates
      end
    end
  end
  def getmonthdataservice
    respond_to do |format|
      format.json do
        c =User.find(current_user)       
        month_date = TeachingPlan.where("trim(to_char(teaching_date, 'Month')) = '#{params[:month]}'")
        month_date = month_date.map do |teach|
          {date: teach.teaching_date, plan_month: teach.plan_month, grade_Section_subject: teach.grade_master.grade_name+"-"+ teach.section_master.section_name+"-"+teach.subject_master.subject_name, :id => teach.id}
        end
        p month_date
        p "###################"
        render :json => month_date
      end
    end
  end


end
