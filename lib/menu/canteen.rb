class Canteen
  
 def initialize(args)
   @controller = args[:controller]
  end
  
  def admin_sub_menu
    sub_menu = []
    sub_menu << home
    sub_menu << meal_types
    sub_menu << daily_meals    
    sub_menu << inventory
  end
  def canteenmanager_sub_menu    
    sub_menu = []
    sub_menu << home       
    sub_menu << daily_meals
    sub_menu << inventory
    sub_menu << food_wastage
  end
  
  def parent_sub_menu
    sub_menu = []
    sub_menu << daily_meals
  end

  def principal_sub_menu
    sub_menu = []
    sub_menu << home
    sub_menu << inventory
  end
    


  private
  
  def meal_types
    MenuItem.new(:label => "Meal Types", :klass => "", :icon => "cutlery", :href => "/mealtypes") 
  end
  
  def daily_meals
    MenuItem.new(:label => "Meal names", :klass => "", :icon => "cutlery", :href => "/mealnames" )
  end

  def home
    MenuItem.new(:label => "Home", :klass => "", :icon => "home ", :href => "/mealtypes/home_index")
  end
  
  def inventory
    MenuItem.new(:label => "Inventories", :klass => "", :icon => "cutlery", :href => "/inventories" )
  end

  
  def food_wastage
    MenuItem.new(:label => "Wastage", :klass => "", :icon => "cutlery", :href => "/food_wastages" )
  end
 
 end
