class EnquiryAdmission

  def initialize(args)
    @controller = args[:controller]

  end

  
  def admin_sub_menu
    sub_menu = []
    sub_menu << home
    sub_menu << show_enquiry_admissions
    sub_menu << show_application_admissions    
    sub_menu << show_assessment_planned
    sub_menu << assessment_completed
    sub_menu << view_management_review
    sub_menu << show_closed_forms
  end

  def principal_sub_menu
    sub_menu = []
    sub_menu << view_management_review
    sub_menu << assessment_completed
    sub_menu << show_assessment_planned
    sub_menu << show_application_admissions    
    sub_menu << show_enquiry_admissions
    sub_menu << show_closed_forms
    sub_menu << selected_students
    end
  


  def parent_sub_menu
    sub_menu = []
    sub_menu << fee_structure
    sub_menu
  end
  
  def accountant_sub_menu
    sub_menu = []
    sub_menu << fee_structure
    sub_menu
  end
 def teacher_sub_menu
   sub_menu = []
   sub_menu << view_schedule
   sub_menu << assessment_completed
   sub_menu << show_closed_forms
   sub_menu
 end
 
  private
  def home
    MenuItem.new(:label => "Home", :klass => "", :icon => "home", :href => "/admissions/admission_home" )
  end
 
  def show_enquiry_admissions
    MenuItem.new(:label => "Enquiry Forms ", :klass => "", :icon => "file", :href => "/admissions/enquiry_index" )
  end
  def show_application_admissions
    MenuItem.new(:label => "Application Forms ", :klass => "", :icon => "file-text", :href => "/admissions/admission_index" )
  end
  def show_assessment_planned
    MenuItem.new(:label => "Assessment Planned ", :klass => "", :icon => "book", :href => "/admissions/assessment_index" )
  end
  def view_schedule
    MenuItem.new(:label => "View Schedule", :klass => "", :icon => "book", :href => "/admissions/assessment_index" )
  end
  def assessment_completed
    MenuItem.new(:label => "Assessment Completed", :klass => "", :icon => "sliders", :href => "/admissions/assessment_completed" )
  end
  def management_review
    MenuItem.new(:label => "Management Review", :klass => "", :icon => "book", :href => "/admissions/assessment_index" )
  end
  def show_closed_forms
    MenuItem.new(:label => "Closed Forms", :klass => "", :icon => "ban", :href => "/admissions/closed_forms" )
  end
  def show_staff_admissions
    MenuItem.new(:label => "Assessments", :klass => "", :icon => "book", :href => "/staffs" )
  end
  def show_event_admissions
    MenuItem.new(:label => "Scheduled Events", :klass => "", :icon => "calendar", :href => "/events" )
  end
  def selected_students
    MenuItem.new(:label => "Selected Forms", :klass => "", :icon => "check", :href => "/admissions/selected_students" )
  end
  def view_management_review
    MenuItem.new(:label => "Final Review", :klass => "", :icon => "calendar", :href => "/admissions/management_index" )
  end
end
