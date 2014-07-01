(function(angular, app) {
    "use strict";
    app.service("teachersGradesService",["$http", function($http) {
        var getFacultyNamesServiceView = function(){
            var url = "/teachers_time_tables/get_faculty_names_view.json"
            return $http.get(url);
        };
        
        var checkTeachersGradesMapping = function(myTeacher){
            //alert("hello");
            var url = "/teacher_grade_mappings/check_teachers_grades_mapping.json"             
            return $http.get(url,{params:{my_Teacher: myTeacher}});  
        }; 

        var saveMappings = function(mappings){
            var url = "/teacher_grade_mappings/savemappings.json"
            return $http.post(url, {_mappings: mappings});
            
        };
        
        var getMappings = function(myTeacher){
            var url = "/teacher_grade_mappings/getmappings.json"
            return $http.post(url, {my_Teacher: myTeacher}); 
        }; 
       
        return {
            getFacultyNamesServiceView : getFacultyNamesServiceView,
            checkTeachersGradesMapping : checkTeachersGradesMapping,
            saveMappings : saveMappings,
            getMappings : getMappings
        };        
    }]);   

})(angular, myApp);