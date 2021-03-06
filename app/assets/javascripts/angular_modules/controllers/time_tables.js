(function(angular, app) {
    "use strict";
    app.controller('TimeTablesController',["$scope", "timeTableService",function($scope,timeTableService) {       
        timeTableService.getGradeServiceView()
            .then(function(result) {
                $scope.grades=result.data; 
            });

        $scope.getSectionsGrades = function (){
            timeTableService.getSectionsForGradeService($scope.myGrade)
                .then(function(result) {
                    $scope.sections=result.data;
                });

            timeTableService.getSubjectsForGradeService($scope.myGrade)
                .then(function(result) {
                    $scope.subjects=result.data;
                });
        };       
        
        //timeTableService.getSubjectServiceView()
            //.then(function(result) {
                //$scope.subjects=result.data                
            //});
        
        timeTableService.getDefaultPeriodsServiceView()
            .then(function(result) {
                $scope.no_of_periods = result.data
            });
        
        timeTableService.getTimeTableServiceView()
            .then(function(result) {               
            });
        
        $scope.addPeriods = function (){             
            $scope.myShowValue="false"
            $scope.myValue="true"           
            $scope.timeperiods = [];

            
            for ( var i = 0; i < $scope.no_of_periods; i++ ) {
                $scope.timeperiods.push({ 
                    grade_master_id: $scope.myGrade,
                    section_master_id: $scope.mySection,
                    mon_sub: "",
                                tue_sub: "",
                    wed_sub: "",
                    thu_sub: "",
                    fri_sub: "",
                    sat_sub: "",
                    sun_sub: "",
                });              
            }
        } ;
        
                       
        $scope.savePeriods = function(){
            $scope.save_timeperiods = [];
            for ( var i = 0; i < $scope.no_of_periods; i++ ) {
                $scope.save_timeperiods.push({
                    id: $scope.timeperiods[i]['id'],  
                    grade_master_id: $scope.myGrade,
                    section_master_id: $scope.mySection,
                    mon_sub: $scope.timeperiods[i]['mon_sub'] == 0 ? null : $scope.timeperiods[i]['mon_sub'],
                    tue_sub: $scope.timeperiods[i]['tue_sub'] == 0 ? null : $scope.timeperiods[i]['tue_sub'],
                    wed_sub: $scope.timeperiods[i]['wed_sub'] == 0 ? null : $scope.timeperiods[i]['wed_sub'],
                    thu_sub: $scope.timeperiods[i]['thu_sub'] == 0 ? null : $scope.timeperiods[i]['thu_sub'],
                    fri_sub: $scope.timeperiods[i]['fri_sub'] == 0 ? null : $scope.timeperiods[i]['fri_sub'],
                    sat_sub: $scope.timeperiods[i]['sat_sub'] == 0 ? null : $scope.timeperiods[i]['sat_sub'],
                    sun_sub: $scope.timeperiods[i]['sun_sub'] == 0 ? null : $scope.timeperiods[i]['sun_sub'],
                });              
            }
           
            timeTableService.savePeriods($scope.save_timeperiods)
                .then(function(result) {
                   
                });
            
            $scope.showPeriods();
        }; 

        $scope.showPeriods = function(){
           
            timeTableService.checkTimeTable($scope.myGrade,$scope.mySection)
                .then(function(result) {
                    $scope.check_time_table = result.data 
                    if ($scope.check_time_table == 0)
                    {                       
                        $scope.myValue = "false"
                        $scope.myShowValue = "false"
                        $scope.addPeriods();
                    }
                    else
                    {                    
                        $scope.myValue="false"
                        $scope.myShowValue="true"                   
                        $scope.getPeriods($scope.myGrade,$scope.mySection);
                    }                   
                });
        };

        $scope.getPeriods = function(grade,section){
            timeTableService.getPeriods(grade,section)
                .then(function(result) {  
                    $scope.timeperiods=result.data                  
                        $scope.myShowValue="true";                   
                });            
        };

        $scope.editPeriods = function(){ 
            $scope.myShowValue="false"
            $scope.myValue="true"
        };

        $scope.clearRowPeriods = function($index){

            $scope.timeperiods[$index]['mon_sub']= "";
            $scope.timeperiods[$index]['tue_sub']= "";
            $scope.timeperiods[$index]['wed_sub']= "";
            $scope.timeperiods[$index]['thu_sub']= "";
            $scope.timeperiods[$index]['fri_sub']= "";
            $scope.timeperiods[$index]['sat_sub']= "";
        };

        $scope.clearColumnPeriods = function($index){
            
            if ($index == 0)
            {
                for ( var i = 0; i < 8; i++ ) {
                    $scope.timeperiods[i]['mon_sub']= "";
                }
            }
            else if ($index == 1)
            {
                for ( var i = 0; i < $scope.no_of_periods; i++ ) {
                    $scope.timeperiods[i]['tue_sub']= "";
                }                
            }
            else if ($index == 2)
            {
                for ( var i = 0; i < $scope.no_of_periods; i++ ) {
                    $scope.timeperiods[i]['wed_sub']= "";
                }                
            }
            else if ($index == 3)
            {
                for ( var i = 0; i < $scope.no_of_periods; i++ ) {
                    $scope.timeperiods[i]['thu_sub']= "";
                }                
            }
            else if ($index == 4)
            {
                for ( var i = 0; i < $scope.no_of_periods; i++ ) {
                    $scope.timeperiods[i]['fri_sub']= "";
                }                
            }
            else if ($index == 5)
            {
                for ( var i = 0; i < $scope.no_of_periods; i++ ) {
                    $scope.timeperiods[i]['sat_sub']= "";
                }                
            }            
        };
        
        $scope.clearAllPeriods = function(){
            for ( var i = 0; i < $scope.no_of_periods; i++ ) {
            $scope.timeperiods[i]['mon_sub']= "";
            $scope.timeperiods[i]['tue_sub']= "";
            $scope.timeperiods[i]['wed_sub']= "";
            $scope.timeperiods[i]['thu_sub']= "";
            $scope.timeperiods[i]['fri_sub']= "";
            $scope.timeperiods[i]['sat_sub']= "";            
            }
        };
        
    }]);

})(angular, myApp);
