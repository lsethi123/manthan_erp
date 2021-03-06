(function(angular, app) {
    "use strict";
    app.controller('TeacherGradeMapController', ["$scope", "teachersGradesService", "teachersService", "timeTableService","academicsService", function($scope, teachersGradesService, teachersService, timeTableService, academicsService) {
        
        var initiateForm = function(){
            $scope.myShowFormValue = false;
        };
        initiateForm();

        
        teachersService.getFacultyNamesServiceView()
            .then(function(result) {
                $scope.faculty_names = result.data                
            });
        
        timeTableService.getGradeServiceView()
            .then(function(result) {
                $scope.grades = result.data               
            });
        
        $scope.getSections = function (){    
            timeTableService.getSectionsForGradeService($scope.myGrade)
                .then(function(result) {
                    $scope.sections=result.data;
                });
        };

        $scope.getSectionsSubjects = function (){    
            academicsService.getSectionsForGradeService($scope.mapping['grade_master_id'])
                .then(function(result) {
                    $scope.sections=result.data;
                });
            academicsService.getAcademicsSubjectsForGradeService($scope.mapping['grade_master_id'])
                .then(function(result) {
                    $scope.subjects=result.data;
                });
        }; 
        
        $scope.getSectionsSubjectsInEdit = function(){  
            $scope.getSectionsSubjects();
            $scope.mapping.section_master_id = "";
            $scope.mapping.subject_master_id = "";
         };
        
        $scope.showMappings = function(){  
            $scope.myShowFormValue = true;
            teachersGradesService.checkTeachersGradesMapping($scope.myTeacher)
                .then(function(result) {
                    $scope.check_teachers_grades_mapping = result.data                    
                    if ($scope.check_teachers_grades_mapping == 0)
                    {
                        $scope.mappings = [];
                        $scope.addMapping();
                    }
                    else
                    {                          
                        teachersGradesService.getMappings($scope.myTeacher)
                            .then(function(result) {  
                                $scope.mappings = result.data;  
                            });
                    }
                });
        };
        
        $scope.addMapping = function (mapping){
            $scope.sections = [];
            $scope.subjects = [];
            $('#myModal').modal('show');
            $scope.mapping = mapping;  
        };

        $scope.editMapping = function (mapping){
            $scope.sections = [];
            $scope.subjects = [];
            $scope.mapping = mapping; 
            $scope.getSectionsSubjects();
            $('#myEditModal').modal('show');                       
        };

        $scope.saveMappings = function(){           
            $scope.save_mappings = [];
           
            for( var j = 0; j <  $scope.mapping['section_master_id'].length; j++ ){
                $scope.save_mappings.push({
                    id: $scope.mapping.id, 
                    faculty_master_id: $scope.myTeacher,
                    grade_master_id:  $scope.mapping.grade_master_id,
                    section_master_id: $scope.mapping.section_master_id[j],
                    subject_master_id: $scope.mapping.subject_master_id,
                }); 
            }
            teachersGradesService.saveMappings($scope.save_mappings)
                .then(function(result) {
                    $('#myModal').modal('hide');   
                    $scope.showMappings();
                });             
        };

        $scope.saveEditMappings = function(){  
            $scope.save_mappings = [];          
            $scope.save_mappings.push({
                id: $scope.mapping.id, 
                faculty_master_id: $scope.myTeacher,
                grade_master_id:  $scope.mapping.grade_master_id,
                section_master_id: $scope.mapping.section_master_id,
                subject_master_id: $scope.mapping.subject_master_id,
            });
            teachersGradesService.saveMappings($scope.save_mappings)
                .then(function(result) {
                    $('#myEditModal').modal('hide');
                    $scope.showMappings();
                });  
        };
       
        $scope.deleteMappings =  function($index){  
            if(confirm("Are you sure want to delete")){
                $scope.delete_Mappping_id = $scope.mappings[$index]['id']
                teachersGradesService.deleteMappings($scope.delete_Mappping_id)
                    .then(function(result) {   
                        $scope.showMappings();
                    });                 
            }else{
            }
        };
        
        $scope.getGradeWiseMappings = function(){
            teachersGradesService.getGradeWiseMappings($scope.myGrade,$scope.mySection)
                .then(function(result) {  
                    $scope.mappings = result.data                  
                }); 
            $scope.myShowGradeWiseFormValue = "true" 
        };

        $scope.cancelMappings = function(){
            $('#myModal').modal('hide');   
        };
        
        
    }]);   
})(angular, myApp);
