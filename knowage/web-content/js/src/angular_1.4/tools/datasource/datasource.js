/**
 * @author Simović Nikola (nikola.simovic@mht.net)
 */
var app = angular.module('dataSourceModule', ['ngMaterial', 'angular_list', 'angular_table' ,'sbiModule', 'angular_2_col']);

app.controller('dataSourceController', ["sbiModule_translate","sbiModule_restServices", "$scope","$mdDialog","$mdToast", "$timeout", dataSourceFunction]);

var emptyDataSource = {
	label : "",
	descr : "",
	urlConnection: "",
	user: "",
	pwd: "",
	driver: "",
	dialectId: "",
	hibDialectClass: "",
	hibDialectName: "",
	schemaSttribute: "",
	multiSchema: false,
	readOnly: false,
	writeDefault: false	
};

function dataSourceFunction(sbiModule_translate, sbiModule_restServices, $scope, $mdDialog, $mdToast, $timeout){
	
	//DECLARING VARIABLES
	$scope.showMe=false;
	$scope.translate = sbiModule_translate;
	$scope.dataSourceList = [];
	$scope.dialects = [];
	$scope.selectedDataSource = {};
	$scope.selectedDataSourceItems = [];
	$scope.isDirty = false;
	$scope.forms = {};
	
	angular.element(document).ready(function () {
        $scope.getDataSources();
    });
	
	$scope.setDirty = function () {
		$scope.isDirty = true;
	}

	//REST
	$scope.getDataSources = function(){
		
		//GET DATA SOURCES
		sbiModule_restServices.get("2.0/datasources", "")
		
		.success(
				
				function(data, status, headers, config) {
					
					if (data.hasOwnProperty("errors")) {
		
						console.log("[GET]: DATA HAS ERRORS PROPERTY!");
						
					} else {
						
						console.log("[GET]: SUCCESS!");
						
						for(var i = 0; i < data.length; i++){
					          $scope.dataSourceList.push(data[i]);
					          console.log(angular.toJson(data[i]));
					    }
						
					}
				})
				
		.error(
				
				function(data, status, headers, config) {
					console.log("[GET]: FAIL!"+status);
				});
		
		//GET DIALECT TYPES
		sbiModule_restServices.get("domains", "listValueDescriptionByType","DOMAIN_TYPE=DIALECT_HIB")
		
		.success(
				
				function(data, status, headers, config) {
					if (data.hasOwnProperty("errors")) {
						
						console.log("[GET/DIALECT]: DATA HAS ERRORS PROPERTY!");
					
					} else {
						console.log("[GET/DIALECT]: SUCCESS!");
						$scope.dialects = data;
						console.log($scope.dialects);
					
					
					}
				})
				
		.error(
				
				function(data, status, headers, config) {
					console.log("[GET/DIALECT]: FAIL!"+status);

		});
	};
	
	//REST
	$scope.saveOrUpdateDataSource = function(){
		
		if($scope.selectedDataSource.hasOwnProperty("dsId")){
			
			//MODIFY DATA SOURCE
			sbiModule_restServices.put('2.0/datasources','',$scope.selectedDataSource)
			
			.success(
			
					function(data, status, header, config) {
						if(data.hasOwnProperty("errors")) {
							console.log("[PUT]: DATA HAS ERRORS PROPERTY!");
						} else {
							console.log("[PUT]: SUCCESS!");
							$scope.dataSourceList = [];
							$timeout(function(){								
								$scope.getDataSources();
							}, 500);
							$scope.closeForm();
						}
					}
					
			).error(
					
					function(data, status, header, config) {
						console.log("[PUT]: FAIL!"+status);
					}
			
			);
		} else {
			
			//CREATE NEW DATA SOURCE
			sbiModule_restServices.post('2.0/datasources','', angular.toJson($scope.selectedDataSource))
			
			.success(
					
					function(data, status, headers, config) {
						if(data.hasOwnProperty("errors")) {
							console.log("[POST]: DATA HAS ERRORS PROPERTY!");
						} else {
							console.log("[POST]: SUCCESS!");
							$scope.dataSourceList = [];
							$timeout(function(){								
								$scope.getDataSources();
							}, 500);
							$scope.showActionOK();
							$scope.closeForm();
						}
					})	
					
			.error(
					
					function(data, status, headers, config) {
						console.log("[POST]: FAIL!"+status);
					}					
			);
		}
		
	};
	
	//REST
	$scope.deleteDataSource = function() {
		
		//DELETE SEVERAL DATA SORUCES
		if($scope.selectedDataSourceItems.length > 1) {
			
			sbiModule_restServices.delete("2.0/datasources",queryParamDataSourceIdsToDelete()).success(
					function(data, status, headers, config) {
						console.log(data);
						if (data.hasOwnProperty("errors")) {
							console.log("[DELETE MULTIPLE]: PROPERTY HAS ERRORS!");
						} else {
							console.log("[DELETE MULTIPLE]: SUCCESS!")
							$scope.showActionMultiDelete();
							$timeout(function(){								
								$scope.dataSourceList = data;
							}, 500);
							$scope.closeForm();
							$scope.selectedDataSourceItems = [];
						}
					}).error(function(data, status, headers, config) {
						console.log("[DELETE MULTIPLE]: FAIL!"+status)
					})
			
		} else {
			
			//DELETE  ONE DATA SOURCE
			sbiModule_restServices.delete("2.0/datasources", $scope.selectedDataSource.dsId).success(

					function(data, status, headers, config) {
						if (data.hasOwnProperty("errors")) {
							console.log("[DELETE]: DATA HAS ERRORS PROPERTY!");
						} else {
							console.log("[DELETE]: SUCCESS!");
							$scope.dataSourceList = [];
							$timeout(function(){								
								$scope.dataSourceList = data;
							}, 500);
							$scope.closeForm();
							$scope.showActionDelete();
						}
					}).error(function(data, status, headers, config) {
						console.log("[DELETE]: FAIL!"+status);
					});
			
		}
		
		
	};
	
	//SHOW RIGHT-COLUMN
	$scope.createNew = function () {
		$scope.forms.dataSourceForm.$setPristine();
		$scope.forms.dataSourceForm.$setValidity();
	    $scope.forms.dataSourceForm.$setUntouched();
		$scope.showme=true;
		$scope.selectedDataSource = {
				label : "",
				descr : "",
				dialectId: "",
				multiSchema: false,
				readOnly: false,
				writeDefault: false,
				urlConnection: "",
				user: "",
				pwd: "",
				driver: ""				
		};
		console.log($scope.selectedDataSource);
		$scope.noDSSelected = false;
	};
	
	//LOAD SELECTED SOURCE
	$scope.loadSelectedDataSource = function(item) {
		
		$scope.showme=true;
			
			if($scope.isDirty==false) {
				
				$scope.selectedDataSource = angular.copy(item);
				
			} else {
				
				

				$mdDialog.show($scope.confirm).then(function() {
					
					
					$scope.selectedDataSource = angular.copy(item);
					$scope.isDirty = false;


				}, function() {
					$scope.showMe = true;
				});
			}
		
	};
	
	//CLOSE RIGHT-COLUMN AND SET SELECTED DATA SORUCE TO AN EMPTY OBJECT
	$scope.closeForm = function(){
		$scope.showme=false;
		$scope.selectedDataSource = angular.copy({});
	};
	
	//CONFIRM DELETE
	$scope.showActionDelete = function() {
		var toast = $mdToast.simple()
		.content('Successfully deleted data source!')
		.action('OK')
		.highlightAction(false)
		.hideDelay(3000)
		.position('top')

		$mdToast.show(toast).then(function(response) {
			if ( response == 'ok' ) {
			}
		});
	};
	
	//CONFIRM MULTIPLE DELETE
	$scope.showActionMultiDelete = function() {
		var toast = $mdToast.simple()
		.content('Successfully deleted multiple data sources!')
		.action('OK')
		.highlightAction(false)
		.hideDelay(3000)
		.position('top')

		$mdToast.show(toast).then(function(response) {
			if ( response == 'ok' ) {
			}
		});
	};
	
	//CONFIRM OK
	$scope.showActionOK = function() {
		var toast = $mdToast.simple()
		.content('Successfully saved data source!!')
		.action('OK')
		.highlightAction(false)
		.hideDelay(3000)
		.position('top')

		$mdToast.show(toast).then(function(response) {

			if ( response == 'ok' ) {
			}
		});
	};
	
	//CREATING PATH FOR DELETING MULTIPLE DATA SOURCES
	queryParamDataSourceIdsToDelete = function(){
		
		   var q="?";
		   
		   for(var i=0; i<$scope.selectedDataSourceItems.length;i++){
			   q+="id="+$scope.selectedDataSourceItems[i].dsId+"&";
		   }
		   
		   return q;
		   
	};
	
	$scope.deleteItem = function (item) {
		console.log(item)
		sbiModule_restServices.delete("2.0/datasources", item.dsId).success(

				function(data, status, headers, config) {
					if (data.hasOwnProperty("errors")) {
						console.log("[DELETE]: DATA HAS ERRORS PROPERTY!");
					} else {
						console.log("[DELETE]: SUCCESS!");
						$scope.dataSourceList = [];
						$timeout(function(){								
							$scope.dataSourceList = data;
						}, 500);
						$scope.closeForm();
						$scope.showActionDelete();
					}
				}).error(function(data, status, headers, config) {
					console.log("[DELETE]: FAIL!"+status);
				});
	}
	
	//SPEED MENU TRASH ITEM
	$scope.dsSpeedMenu= [
	                     {
	                    	label:'delete',
	                    	icon:'fa fa-trash-o fa-lg',
	                    	color:'#153E7E',
	                    	action:function(item,event){
	                    		
	                    		$scope.deleteItem(item);
	                    	}
	                     }
	                    ];

	$scope.confirm = $mdDialog
	.confirm()
	.title(sbiModule_translate.load("sbi.layer.modify.progress"))
	.content(
			sbiModule_translate
			.load("sbi.layer.modify.progress.message.modify"))
			.ariaLabel('Lucky day').ok(
					sbiModule_translate.load("sbi.general.continue")).cancel(
							sbiModule_translate.load("sbi.general.cancel"));
	
};