(function(angular, app) {
    "use strict";
    app.service("gradeWiseFeeService",["$http", function($http) {
        var getGradewiseFeeView = function(){
            var url = "/grade_wise_fees/grade_wise_fee_view.json"
            return $http.get(url);
        };

        var saveBucketWiseFee = function(gradeWiseFees){
            var url = "/grade_wise_fees/save_grade_wise_fee_grid.json"
            return $http.post(url, {params: gradeWiseFees});
        };

        var student_fee_structure = function(student){
            var url = "/grade_wise_fees/grade_wise_fee_of_student?student_id="+student+".json"
            return $http.get(url);
        }

        
        return {
            getGradewiseFeeView : getGradewiseFeeView,
            saveBucketWiseFee : saveBucketWiseFee
        };
        
    }]);
})(angular, myApp);
