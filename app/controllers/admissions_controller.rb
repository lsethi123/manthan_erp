class AdmissionsController < ApplicationController
 

  def get_klass_view
    klass = TeacherLeader.all.map do |klass|
      { grade_name: klass.klass,faculty_name: klass.faculty_leader, id: klass.id}
    end
    render :json => klass
  end
  
  def index
    if params[:teacher_leader_id].present?
      @admissions = Admission.where(:teacher_leader_id => params[:teacher_leader_id])
    else
      @admissions = Admission.all
      #respond_to do |format|
      # format.html
      # format.json { render :json => @admission}
    end
  end
  
  def create
    @admission = Admission.new(admission_params)
    @admission.teacher_leader = TeacherLeader.where(:klass => admission_params[:grade]).first
    respond_to do |format|
      if @admission.save 
        format.html { redirect_to admission_home_admissions_path, notice: 'Enquiry was successfully created.' }
        format.json { render action: 'enquiry_show', :status => "enquiry_created", location: @admission }
      else
        format.html { render action: 'new' }
        format.json { render json: @admission.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def new
    @admission = Admission.new
  end
  
  def edit
    @admission = Admission.find(params[:id])
  end
  
  def show
    @admissions = Admission.all
  end
  
  def admission_home
    if params[:search].present?
      @admissions = Admission.search(params[:search])
    else
      @admissions = Admission.enquiry_forms_or_application_forms  
    end
  end
  
  def home_index
    @admission = Admission.find(params[:id])
  end
  
  def enquiry_new
    @admission = Admission.new
  end
  
  def admission_new
    @admission = Admission.find(params[:id])
  end
  
  def assessment_new
    @admission = Admission.find(params[:id])
  end
  
  def enquiry_index
    if params[:search].present?
      @admissions = Admission.search(params[:search])
    else
      @admissions = Admission.enquiry_forms
    end
  end
  
  def admission_index
    if params[:search].present?
      @admissions = Admission.search(params[:search])
    else
      @admissions = Admission.application_forms
    end
  end
  
  def assessment_index
    if params[:search].present?
      @admissions = Admission.search(params[:search])
    else
      @admissions = Admission.assessment_planned
    end
  end
  
  def management_index
    if params[:search].present?
      @admissions = Admission.search(params[:search])
    else
      @admissions = Admission.management_review
    end
  end
  
  def edit_application
    @admission = Admission.find(params[:id])
  end
  
  def edit_assessment
    @admission = Admission.find(params[:id])
  end

  def edit_assessment_result
    @admission = Admission.find(params[:id])
  end
  
  def enquiry_show
    @admission = Admission.find(params[:id])
  end
  
  def admission_show
    @admission = Admission.find(params[:id])
  end
  
  def assessment_show
    @admission = Admission.find(params[:id])
  end
  
  def assessment_completed
    
    if params[:search].present?
      @admissions = Admission.search(params[:search])
    else
      @admissions = Admission.assessment_completed
    end
  end
  
  def view_assessment
    @admission = Admission.find(params[:id])
  end

  def assessment_result
    @admission = Admission.find(params[:id])
  end

  def management_result
    @admission = Admission.find(params[:id])
  end

  def selected_students
    if params[:search].present?
      @admissions = Admission.search(params[:search])
    else
      @admissions = Admission.selected_students
    end
  end
  
  def closed_forms
    @admissions = Admission.closed_forms
  end
  
  def update_enquiry
    @admission = Admission.find(params[:id])
    respond_to do |format|
      if @admission.update(admission_params)
        format.html { redirect_to admission_home_admissions_path, notice: 'Form was successfully updated.' }
        format.json { render action: 'index', :status => "success" }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admission.errors, :status => "failure" }
      end
    end
  end
  
 def update
   @admission = Admission.find(params[:id])
   respond_to do |format|
     if @admission.update!(admission_params)
       if @admission.status == "Application_Created"
         new_student_master = get_student_master(@admission)
         if new_student_master.valid?
           new_student_master.save!
         else
         end
         new_parent_master = get_parent_master(@admission)
         if new_parent_master.valid?
           new_parent_master.save!
         else
         end
       end
       format.html { redirect_to admission_home_admissions_path, notice: 'Form was successfully updated.' }
       format.json { render action: 'index', :status => "success" }
     else
       format.html { render action: 'edit' }
       format.json { render json: @admission.errors, :status => "failure" }
     end
   end
 end
 
 def update_admission
   @admission = Admission.find(params[:id])
   respond_to do |format|
     if  @admission.update(:status => "Form_Closed")
       format.json { render action: 'index', :status => "success" }
     else
       format.json { render json: @admission.errors, :status => "failure" }
     end
   end
 end
 
 def update_assessment
   @admission = Admission.find(params[:id])
   respond_to do |format|
     if @admission.update(admission_params)
       format.html { redirect_to admission_home_admissions_path, notice: 'Form was successfully updated.' }
       format.json { render action: 'index', :status => "success" }
     else
       format.html { render action: 'edit' }
       format.json { render json: @admission.errors, :status => "failure" }
     end
   end
 end
 def destroy
   @admission = Admission.find(params[:id])
   @admission.destroy
   respond_to do |format|
     format.html { redirect_to admission_index_admissions_path }
   end
 end
 
 def admission_params
   params.require(:admission).permit(:admission_no,:branch,:surname,:second_lang,:board,:grade,:medium,:year,:written,:spoken,:reading,:blood_group,:allergy,:doctor_name,:doctor_mobile,:guardian_name,:guardian_mobile,:guardian_relationship,:from,:to,:avatar,:father_office_address,:mother_office_address,:father_office_telephone,:mother_office_telephone,:father_mobile,:mother_mobile,:father_religion,:mother_religion,:father_employer,:mother_employer,:father_email,:mother_email,:sib_name,:sib_age,:sib_sex,:sib_grade,:sib_school,:bus,:form_no, :middle_name,:name,:klass, :dob,:gender,:nationality,:language,:father_name,:mother_name,:father_occupation,:mother_occupation,:father_company,:mother_company,:father_education, :mother_education,:income,:address, :landline,:mobile,:email,:transport, :busstop,:last_school, :city, :changing_reason, :know_school,:person, :pp,:status,:closestatus,:title, :description, :staff, :grade, :start_time, :end_time, :grade_master_id,:teacher_leader_id,:faculty,:comment, :result,:teachercomment,:finalresult)
 end
 def get_student_master(student_obj)
     StudentMaster.new do |sm|
       sm.admission_no = student_obj.admission_no
       sm.name = student_obj.name
       sm.branch = student_obj.branch
       sm.description = student_obj.description
       sm.start_time = student_obj.start_time
       sm.end_time = student_obj.end_time
       sm.surname = student_obj.surname
       sm.second_lang = student_obj.second_lang
       sm.board = student_obj.board
       sm.medium = student_obj.medium
       sm.year = student_obj.year
       sm.written = student_obj.written
       sm.spoken = student_obj.spoken
       sm.reading = student_obj.reading
       sm.blood_group = student_obj.blood_group
       sm.finalresult = student_obj.finalresult
       sm.form_no = student_obj.form_no
       sm.guardian_relationship = student_obj.guardian_relationship
       sm.guardian_name = student_obj.guardian_name
       sm.closestatus = student_obj.closestatus
       sm.dob = student_obj.dob
       sm.address = student_obj.address
       sm.gender = student_obj.gender
       sm.email = student_obj.email
       sm.mobile = student_obj.mobile
       sm.nationality = student_obj.nationality
       sm.klass = student_obj.klass
       sm.language = student_obj.language
       sm.allergy = student_obj.allergy
       sm.doctor_name = student_obj.doctor_name
       sm.doctor_mobile = student_obj.doctor_mobile
       sm.from = student_obj.from
       sm.to = student_obj.to
       sm.father_name = student_obj.father_name
       sm.mother_name = student_obj.mother_name
       sm.income = student_obj.income
       sm.landline = student_obj.landline
       sm.transport = student_obj.transport
       sm.busstop = student_obj.busstop
       sm.last_school = student_obj.last_school
       sm.city = student_obj.city
       sm.changing_reason = student_obj.changing_reason
       sm.know_school = student_obj.know_school
       sm.person = student_obj.person
       sm.pp = student_obj.pp
       sm.status = student_obj.status
       sm.sib_name = student_obj.sib_name
       sm.sib_age = student_obj.sib_age
       sm.sib_sex = student_obj.sib_sex
       sm.sib_grade = student_obj.grade
       sm.sib_school = student_obj.sib_school
       sm.grade_master_id = student_obj.grade_master_id
     end 
 end

 def get_parent_master(student_obj)
   ParentMaster.new do |sm|
     sm.father_name = student_obj.father_name
     sm.mother_name = student_obj.mother_name
     sm.father_mobile = student_obj.father_mobile
     sm.mother_mobile = student_obj.mother_mobile
     sm.father_email = student_obj.father_email
     sm.mother_email = student_obj.mother_email
     sm.father_office_address = student_obj.father_office_address
     sm.mother_office_address = student_obj.mother_office_address
     sm.father_occupation = student_obj.father_occupation
     sm.mother_occupation = student_obj.mother_occupation
     sm.father_religion = student_obj.father_religion
     sm.mother_religion = student_obj.mother_religion
     sm.father_company = student_obj.father_company
     sm.mother_company = student_obj.mother_company
     sm.father_education = student_obj.father_education
     sm.mother_education = student_obj.mother_education
     sm.father_office_telephone = student_obj.father_office_telephone
     sm.mother_office_telephone = student_obj.mother_office_telephone
     sm.father_employer = student_obj.father_employer
     sm.mother_employer = student_obj.mother_employer
     sm.student_master_id = student_obj.id
   end
 end
end
