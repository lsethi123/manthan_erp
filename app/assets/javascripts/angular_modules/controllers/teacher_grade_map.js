(function(angular, app) {
    "use strict";
    app.controller('TeacherGradeMapController', ["$scope", "teachersGradesService", "teachersService","gradeService", "sectionService", "subjectService", function($scope, teachersGradesService, teachersService, gradeService, sectionService, subjectService) {
        
        teachersService.getFacultyNamesServiceView()
            .then(function(result) {
                $scope.faculty_names=result.data                
            });
        
        gradeService.getGradeServiceView()
            .then(function(result) {
                $scope.grades=result.data                
            });

        sectionService.getSectionServiceView()
            .then(function(result) {
                $scope.sections=result.data
                
            });  
        
        subjectService.getSubjectServiceView()
            .then(function(result) {
                $scope.subjects=result.data
                
            });        
       
        $scope.showMappings = function(){  
            teachersGradesService.checkTeachersGradesMapping($scope.myTeacher)
                .then(function(result) {
                    $scope.check_teachers_grades_mapping = result.data 
                    //alert($scope.check_teachers_grades_mapping)
                    if ($scope.check_teachers_grades_mapping == 0)
                    {
                        $scope.myNewEditFormValue = "false"
                        $scope.myShowFormValue = "false"
                        $scope.addMappings();
                    }
                    else
                    {
                        
                        $scope.myNewEditFormValue = "false"
                        $scope.myShowFormValue = "true"           
                        teachersGradesService.getMappings($scope.myTeacher)
                            .then(function(result) {  
                                $scope.mappings = result.data
                                //alert(JSON.stringify($scope.mappings))
                            });
                    }
                });
        };


        $scope.addMappings = function (){
            $scope.myNewEditFormValue="true"
            $scope.mappings = [];      
            for ( var i = 0; i < 1 ; i++ ) {
                $scope.mappings.push({ 
                    faculty_master_id: $scope.myTeacher,
                    grade_master_id: "",
                    grade_name: "",
                    section_master_id: "",
                    section_name: "",
                    subject_master_id: "",
                    subject_name: "",
                });              
            } 
           
        };

        $scope.saveMappings = function(){
            //alert(JSON.stringify($scope.mappings));
            //alert($scope.mappings.length);
            $scope.save_mappings = [];
            for ( var i = 0; i <  $scope.mappings.length; i++ ) {
                $scope.save_mappings.push({
                    id: $scope.mappings[i]['id'],  
                    faculty_master_id: $scope.myTeacher,
                    grade_master_id: $scope.mappings[i]['grade_master_id'] == 0 ? null : $scope.mappings[i]['grade_master_id'],
                    section_master_id: $scope.mappings[i]['section_master_id'] == 0 ? null : $scope.mappings[i]['section_master_id'],
                    subject_master_id: $scope.mappings[i]['subject_master_id'] == 0 ? null : $scope.mappings[i]['subject_master_id'],                  
                });              
            }

            teachersGradesService.saveMappings($scope.save_mappings)
                .then(function(result) {
                    
                }); 
            $scope.showMappings();
        };
        
        $scope.editMappings = function(){ 
            $scope.myShowFormValue="false"
            $scope.myNewEditFormValue="true"
        };       
        
    }]);
    
})(angular, myApp);