//function myFunction(date){
    
  //  angular.element($('.myFunction')).scope().dailyAttendence(date)
//}

$(document).ready(function() { 
   
    var monthNames = [ "January", "February", "March", "April", "May", "June",
                       "July", "August", "September", "October", "November", "December" ]
    var today = new Date();
    var currentMonth = today.getMonth();
    var currentDate = today.getDate();
    var currentYear = today.getFullYear();
    $('#attendance_calendar').html("");
    $('#attendance_calendar').fullCalendar({      
        events: '/holidaycalendars/holidaycalendardata.json?month='+monthNames[today.getMonth()],
        selectable: true,
        
        eventMouseover: function(data, event, view) {            
          
	},
       
        select: function(date) {
           // var checkUrl = "holidaycalendars/holiday_exists.json?date="+dateFormat    
            angular.element($('#myTable')).scope().dailyAttendence(date)
                        
        }            
    });
    });

