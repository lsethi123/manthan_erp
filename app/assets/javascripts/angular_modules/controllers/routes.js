(function(angular, app) {
    "use strict";
    app.controller("RouteController",["$scope","resourceService", function($scope, resourceService) {
	$scope.routes = resourceService.Route.query();
        
	$scope.defineNew = function(){
	    $scope.newRoute = new resourceService.Route({"busno_up":"", "no_of_children":"", "route_no":"", "locations":[]})
	    for(var i=0; i<1; i++){
                $scope.newRoute.locations.push({"location":"" , "sequence_no": "" });
            };
            $('#createModal').modal('show')
        }
	
        $scope.submitRoutes = function(){
	    $scope.newRoute.$save()
	        .then(function(responce){
	    	    $scope.routes = resourceService.Route.query()
                    $('#createModal').modal('hide')
	    	})
	}
	
        $scope.addMoreterms = function(){
	    var lnt = parseInt($scope.newRoute.locations.length)
            for(var i=lnt; i< lnt+1; i++){
                $scope.newRoute.locations.push({"location":"" ,"sequence_no":""});
            };
        }
    }]);
    
})(angular, myApp);
