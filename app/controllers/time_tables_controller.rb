class TimeTablesController < ApplicationController
  def index
  end

  def gradeserviceview
    respond_to do |format|
      format.json do
        grades = GradeMaster.all.map do |grade|
          {grade: grade.grade_name, id: grade.id}
        end
        render :json => grades
      end
    end  
  end

  def sectionserviceview
    respond_to do |format|
      format.json do
        sections = SectionMaster.all.map do |section|
          {section: section.section, id: section.id, grade_master_id: section.grade_master_id }
        end
        render :json => sections
      end
    end  
  end
  
  def subjectserviceview
    respond_to do |format|
      format.json do
        sections = SubjectMaster.all.map do |subject|
          {subject: subject.subject, id: subject.id}
        end
        render :json => sections
      end
    end  
  end

  def subjectserviceview
    respond_to do |format|
      format.json do
        sections = SubjectMaster.all.map do |subject|
          {subject: subject.subject, id: subject.id}
        end
        render :json => sections
      end
    end  
  end

  def saveperiods
    params[:time_periods].each do |t|
      @timetable=TimeTable.new(t)
      @timetable.save      
    end
  end

  def timetableserviceview
    respond_to do |format|
      format.json do
        timetables = TimeTable.all
        render :json => timetables
      end
    end  
  end

  def getperiods
    getsubjects=SubjectMaster.all   
    timetables = TimeTable.where('grade_master_id = '+"'#{params[:my_Grade]}'"+" AND "+'section_master_id = '+"'#{params[:my_Section]}'")
    
    timetables = timetables.map do |timetable|
      {id: timetable.id, mon_sub: timetable.mon_sub.to_i,tue_sub: timetable.tue_sub.to_i, wed_sub: timetable.wed_sub.to_i, thu_sub: timetable.thu_sub.to_i, fri_sub: timetable.fri_sub.to_i, sat_sub: timetable.sat_sub.to_i, mon_sub_name: SubjectMaster.get_sub_name(timetable.mon_sub.present?), tue_sub_name: SubjectMaster.get_sub_name(timetable.tue_sub.present?),wed_sub_name: SubjectMaster.get_sub_name(timetable.wed_sub.present?),thu_sub_name: SubjectMaster.get_sub_name(timetable.thu_sub.present?),fri_sub_name: SubjectMaster.get_sub_name(timetable.fri_sub.present?),sat_sub_name: SubjectMaster.get_sub_name(timetable.sat_sub.present?)}
      end    
    render :json => timetables
  end

  def defaultperiodsserviceview
    defaultperiods = DefaultMaster.all
    defaultperiods = DefaultMaster.where('default_name = '+"'no_of_periods'")
    defaultperiods = defaultperiods[0].default_value
    render :json => defaultperiods
  end

end
