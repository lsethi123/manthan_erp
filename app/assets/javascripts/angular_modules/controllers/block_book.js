(function(angular, app) {
    "use strict";
    app.controller("BlockbooksController",["$scope","resourceService", "blockBookService", function($scope, resourceService, blockBookService) {        
        $scope.blockBooks = resourceService.BlockBook.query()       
        
        blockBookService.getbookServiceView()
            .then(function(result) {
                $scope.block_books = result.data
            });
        
        $scope.Go = function(){  
            blockBookService.getBooks($scope.myIsbn)
                .then(function(result) {
                    $scope.books=result.data
                    $scope.bookName = result.data[0]['name']
                    $scope.authorName = result.data[0]['author']
                    $scope.bookId = result.data[0]['id']
                });            
        };
        
        $scope.save = function(){
            var isbn = $("#isbn").val()
            blockBookService.saveBooks($scope.bookId, $scope.myBlock,$scope.myIsbn,$scope.bookName,$scope.authorName)
                .then(function(result) {
                    $scope.books=result.data
                });
            
            $('#myModal').modal('hide');   
            $scope.showBlockBooks();
        };   
  
        $scope.submit = function(){
            var isbn = $("#isbn").val()
            blockBookService.damageBooks($scope.myIsbn,$scope.bookName,$scope.authorName,$scope.bookStage,$scope.damageType,$scope.damageDescription)
                .then(function(result) {
                    $scope.books=result.data;
                });
        };  
        
        $scope.showBlockBooks = function(){
            
        };
        
        $scope.destroy= function(blockBook){
            if(confirm("Are you sure want to delete")){
                $scope.blockBooks.splice($scope.blockBooks.indexOf(blockBook), 1)
                blockBook.$delete()
                    .then(function(responce){                       
                    })            
            }else{                
            }
        };
        
        
        
    }]);
})(angular, myApp)
