module ApplicationHelper
  def flash_alert_class(key)
    key = 'danger' if key == :error or key == :alert
    alert_class = ["alert"]
    alert_class << "alert-dismissable"
    if key.to_s == "fail"
      alert_class << "alert-danger "
    elsif key == :notice
      alert_class << "alert-info "
    else
      alert_class << "alert-#{key}"
    end
    alert_class.join(" ")
  end
  
  def main_menu_list

    user_menu = UserMenu.new(current_user, nil, controller.controller_name)
    user_menu.main_menu
  end

  def sub_menu
    user_menu = UserMenu.new(current_user, ContextDetector.get_context(:key => controller.controller_name, :context => params[:context], :params => params))
    user_menu.sub_menu
  end

  def user_menu
    
  end

  def fee_items_can_be_manipulate?
    @value ||= !ApprovalItem.fee_can_be_edit?
  end

  def fee_structure_defined?
    @value ||= GradeWiseFee.fee_structure_defined?
  end
  
  

end

