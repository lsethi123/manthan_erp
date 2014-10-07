class Admission < ActiveRecord::Base
  has_one :default_master

  before_save :get_form_no

  def get_form_no
    
  end
  belongs_to :parent_master
  belongs_to :student_master
  belongs_to :grade_master
  belongs_to :teacher_leader,:foreign_key => 'teacher_leader_id'
  scope :enquiry_forms_or_application_forms, lambda{where("status = 'Enquiry_Created' or status = 'Application_Created' or status = 'Assessment_Planned' or status = 'Assessment_Completed' or status = 'Management_Reviewed' or status = 'Selected'")}
  scope :closed_forms,lambda{where("status = 'Form_Closed'")}
  scope :enquiry_forms,lambda{where("status = 'Enquiry_Created'")}
  scope :application_forms,lambda{where("status = 'Application_Created'")}
  scope :assessment_planned,lambda{where("status = 'Assessment_Planned'")}
  scope :assessment_completed,lambda{where("status = 'Assessment_Completed'")}
  scope :management_review,lambda{where("status = 'Management_Reviewed'")}
  scope :selected_students,lambda{where("finalresult = 'Selected' and status != 'Form_Closed'" )}
  scope :search, lambda {|id| where(:id => id)}
  def self.search(search)
    if search 
      find(:all, :conditions => ['status LIKE ? ', "%#{search}%"])
    else
      find(:all)
    end
  end
end
