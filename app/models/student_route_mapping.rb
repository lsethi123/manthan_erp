class StudentRouteMapping < ActiveRecord::Base
  belongs_to :student_master
  belongs_to :location_master
  belongs_to :route
  
  scope :show_all_students, lambda{|route_id| where(:route_id => route_id ).select(:student_master_id)}
  scope :show_all_locations, lambda{|location_master_id| where(:location_master_id => location_master_id ).select(:student_master_id)}
  
  def student_length
    route = self.id
    map = StudentRouteMapping.show_all_students(route).map {|student| student.student_master_id}
    return map.length
  end
end
