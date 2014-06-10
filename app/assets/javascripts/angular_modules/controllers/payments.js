(function(angular, app) {
    "use strict";
    app.controller("PaymentsController",["$scope","$location", "paymentService",  function($scope, $location, paymentService) {
        $scope.student_id = ""
        $scope.go = function (code, student_id ) {
            $scope.student_id = student_id
            var path = "/"
            if(code == "annual"){
                path = "/annual_payment"
            }else if (code == "term_wise"){
                path = "/term_wise_payment"
            }else{
                path = "/monthly_payment"
            }
            $location.path( path );
        };

        $scope.annaul_fee_payment_details = function(){
        };
        
        $scope.term_fee_payment_details = function(){
            paymentService.student_current_term_fee($scope.student_id)
                .then(function(response){
                    $scope.term = response.data
                });
        };

        $scope.month_fee_payment_details = function(){
            paymentService.student_monthly_pdcs($scope.student_id)
                .then(function(response){
                    $scope.monthlyFees = response.data
                });
        };
    }]);
    
})(angular, myApp);