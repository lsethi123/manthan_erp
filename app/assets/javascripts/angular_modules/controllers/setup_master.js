(function(angular, app) {
    "use strict";
    app.controller('SetupMasterController',["$scope","resourceService","setupmasterService", function($scope, resourceService, setupmasterService) {
        
        var timeString = "12:00:00"; 
        var H = +timeString.substr(0, 2);
        var h = (H % 24) || 24;
        var ampm = H < 12 ? "AM" : "PM";
        timeString = h + timeString.substr(2, 3) + ampm;
        
        var timeString1 = new Date().toTimeString();  
        var H1 = +timeString1.substr(0, 2);
        var h1 = (H1 % 24) || 24;
        var ampm1 = H1 < 12 ? "AM" : "PM";
        timeString1 = h1 + timeString1.substr(2, 3) + ampm1;
        
      

        //-----------------------------Setup Master

        $scope.masters = resourceService.SetupMaster.query();

        $scope.edit = function(master){
            $scope.master = master
            $('#edit').modal('show');
        }

        $scope.setupupdate = function(){
            $scope.master.$update()
            .then(function(response){
            })
            $('#edit').modal('hide');
            $scope.masters = resourceService.SetupMaster.query();
            window.location.reload();
        };
        //-----------------------------------------


        setupmasterService.getDesignation()
            .then(function(result) {
                $scope.designations = result.data;
            });


        setupmasterService.getDetails()
            .then(function(result) {
                $scope.details = result.data;
            });

        
        setupmasterService.getFaculty()
            .then(function(result) {
                $scope.faculties = result.data;
            });

        setupmasterService.getCountno()
            .then(function(result) {
                $scope.counts = result.data;
            });


        // setupmasterService.getAllDates()
        //     .then(function(result) {
        //         alert(JSON.stringify($scope.all_details))
        //         $scope.all_details = result.data;
        //     });


        $scope.goToEdit = function(){
            $scope.myShowFormValue = false;
            $scope.myEditFormValue = true;
        }

        $scope.goToEdit1 = function(){
            $scope.myShowFormValue1 = false;
            $scope.myEditFormValue1 = true;
        }

        $scope.leave_options ={"casual leave":"casual leave","sick leave":"sick leave"};
        $scope.leave_update = function(type_of_leave) {
            setupmasterService.getCountno(type_of_leave)
                .then(function(result) {
                    if (type_of_leave == "casual leave")
                    {
                        $scope.showCasualLeave = true;
                        $scope.showSickLeave = false;
                        $scope.leaves = result.data;
                        alert(JSON.stringify($scope.leaves))
                    }
                    else 
                    {
                        $scope.showCasualLeave = false;
                        $scope.showSickLeave = true;
                        $scope.leaves = result.data;
                        alert(JSON.stringify($scope.leaves))
                    }
                });
        }


        $scope.getUpdate = function(designation){
            window.drawAttendance(designation)
            setupmasterService.getMonth(designation)
                .then(function(result) {
                    if (timeString > timeString1)
                    {
                        $scope.myShowFormValue = true;
                        $scope.myEditFormValue = false;
                        $scope.faculty_masters = result.data;
                    }
                    else 
                    {
                        $scope.myShowFormValue1 = true;
                        $scope.myEditFormValue1 = false;
                        $scope.faculty_masters = result.data;
                    }

                });
        }
        
        $scope.todayAttendence = function(date){
            var date = new Date();
            $scope.date = (date.getFullYear() + "-" + (date.getMonth()+1) +"-"+date.getDate()); 
            $scope.faculty_masters = $scope.faculty_masters;
            $scope.$apply();
        }
                
        $scope.reflectStaffs = function(facultys){
            $scope.faculty_masters = facultys;
            alert(JSON.stringify(facultys))
            $scope.$apply();
            $scope.save_today_attendence = [];
                for(var i=0; i<facultys.length; i++){
                    $scope.save_today_attendence.push({
                        type_of_leave: null,
                        pending_casual_leave: null,
                        pending_sick_leave: null,
                        max_casual_leave: null,
                        max_sick_leave: null,
                        afternoon: null,
                        forenoon: null,
                        attendance_date: null,
                        name: null,
                        designation: null,
                        faculty_master_id: null,
                        id: null,
                    });
                }
        
        }
        
        setupmasterService.getAttendanceServiceView()
            .then(function(result) {
                $scope.faculty_masters = result.data;
            });


        $scope.saveTodayAttendance = function(){
            for(var i=0; i < $scope.save_today_attendence.length; i++){
                $scope.save_today_attendence[i]['type_of_leave'] = $scope.faculty_masters[i]['type_of_leave'];
                $scope.save_today_attendence[i]['pending_casual_leave'] = $scope.faculty_masters[i]['pending_casual_leave'];
                $scope.save_today_attendence[i]['pending_sick_leave'] = $scope.faculty_masters[i]['pending_sick_leave'];
                $scope.save_today_attendence[i]['max_casual_leave'] = $scope.faculty_masters[i]['max_casual_leave'];
                $scope.save_today_attendence[i]['max_sick_leave'] = $scope.faculty_masters[i]['max_sick_leave'];
                $scope.save_today_attendence[i]['designation'] = $scope.faculty_masters[i]['designation'];
                $scope.save_today_attendence[i]['forenoon'] = $scope.faculty_masters[i]['forenoon'];
                $scope.save_today_attendence[i]['afternoon'] = $scope.faculty_masters[i]['afternoon'];
                $scope.save_today_attendence[i]['attendance_date'] = $scope.faculty_masters[i]['attendance_date']; 
                $scope.save_today_attendence[i]['name'] = $scope.faculty_masters[i]['name'];
                $scope.save_today_attendence[i]['faculty_master_id'] = $scope.faculty_masters[i]['faculty_master_id'];
                $scope.save_today_attendence[i]['id'] = $scope.faculty_masters[i]['id'];
            }
            alert(JSON.stringify($scope.save_today_attendence))
            
            setupmasterService.saveTodayAttendance($scope.save_today_attendence)
                .then(function(result) {
                    if (timeString > timeString1)
                    {
                        $scope.myShowFormValue = true;
                        $scope.myEditFormValue = false;
                    }
                    else
                    {
                        $scope.myShowFormValue1 = true;
                        $scope.myEditFormValue1 = false;

                    }
                    

                });
        }; 
        


    }]);
})(angular, myApp);
