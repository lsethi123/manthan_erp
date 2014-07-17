class ClassTeacherMapping < ActiveRecord::Base
  validates :faculty_master_id , :uniqueness => true

  belongs_to :grade_master
  belongs_to  :section_master  
  belongs_to  :faculty_master
end