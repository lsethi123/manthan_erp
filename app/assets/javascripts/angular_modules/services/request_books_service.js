(function(angular, app) {
    "use strict";
    app.service("requestBooksService",["$http", function($http) {
        var updateBooksStatus = function(resquest_books_status){           
            var url = "/request_books/update_request_books_status.json"
            return $http.post(url, {resquest_books_status: resquest_books_status});
        };              
            
        return {
            updateBooksStatus : updateBooksStatus           
        };
    }]);
})(angular, myApp);
