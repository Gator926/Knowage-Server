(function(){

var app = angular.module("eventModule").controller("eventController",["$scope","eventService","sbiModule_messaging", function ($scope,eventService,sbiModule_messaging){

	$scope.eventSelectModel = ["SCHEDULER", "ETL", "COMMONJ", "DATA_MINING"]
	$scope.pageChangedFun = function(itemsPerPage, currentPageNumber) {

		$scope.fetchsize = itemsPerPage;

		$scope.offset = 0;

		if(currentPageNumber > 1) {
			$scope.offset = (currentPageNumber -1) * $scope.fetchsize;
		}

		$scope.filter = {
			offset: $scope.offset,
			fetchsize: itemsPerPage
		}

		if($scope.startDate != undefined) {
			$scope.filter.startDate = $scope.startDate;
		}

		if($scope.endDate != undefined) {
			$scope.filter.endDate = $scope.endDate;
		}

		if($scope.type != undefined) {
			$scope.filter.type = $scope.type;
		}

		eventService.getAllEvents($scope.filter).then(function(response) {
			$scope.events = response.data.results;
			$scope.totalItemCountt = response.data.total;

		}, function(response) {
			sbiModule_messaging.showErrorMessage(response.data.errors[0].message, "Error");

		});

	}

	$scope.showDetail = false;
	$scope.selectedDetail = {};

	$scope.loadDetail = function(item){
		$scope.showDetail = true;
		$scope.selectedDetail = angular.copy(item);

	}

	$scope.searchEvents = function (){

		if($scope.startDate){
			var startDateFormat = moment($scope.startDate).format("YYYY-MM-DD HH:mm:ss");
			$scope.filter.startDate = startDateFormat;

		}

		if($scope.endDate){
			var endDateFormat = moment($scope.endDate).format("YYYY-MM-DD HH:mm:ss");
			$scope.filter.endDate = endDateFormat;
		}

		if($scope.type){
			var type = $scope.type;
			$scope.filter.type = type;

		}

		eventService.getAllEvents($scope.filter)
		.then(function(response){
			$scope.events=response.data.results;
		},	  function(response){

			sbiModule_messaging.showErrorMessage(response.data.errors[0].message, "Error");

		});

	}

}])

}())