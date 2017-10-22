var restcompany = angular.module('restcompany', []);

restcompany.controller('mainController', ['$scope', '$http', 
    function ($scope, $http) {
    
    $scope.companies=[];
    $scope.companyDetails;
    $scope.name;
    $scope.cvr;
    $scope.address;
    $scope.city;
    $scope.country;
    $scope.phone;

    $scope.getCompanyDetails = function (cvr) {
        $http.get('/v1/company/'+cvr, {}).then($scope.companyDetailsSucceeded, $scope.companyDetailsFailed);
    }

    $scope.companyDetailsSucceeded = function(response) {
        $scope.companyDetails=response.data;
    }

    $scope.companyDetailsFailed = function(response) {
        alert("DETAILS FAIL");
    }

    $scope.getCompanyList = function () {
        $http.get('/v1/company').then($scope.companyListSuceeded, $scope.companyListFailed);
    }

    $scope.companyListSuceeded = function(response) {
        $scope.companies=response.data;
    }

    $scope.companyListFailed = function(response) {
        alert("LIST FAIL");
    }

    

    $scope.companyCreate = function() {
        data = {
            'name': $scope.name,
            'cvr': $scope.cvr,
            'address': $scope.address,
            'city': $scope.city,
            'country': $scope.country
        }
        if ($scope.phone) {
            data['phone'] = $scope.phone;
        }
        $http.post('/v1/company', data, {}).then($scope.companyCreateSuceeded, $scope.companyCreateFailed);
    }

    $scope.companyCreateSuceeded = function(response) {
        $scope.getCompanyList();
        $scope.getCompanyDetails($scope.cvr);
        
        $scope.name=null;
        $scope.cvr=null;
        $scope.address=null;
        $scope.city=null;
        $scope.country=null;
        $scope.phone=null;
    }

    $scope.companyCreateFailed = function(response) {
        alert("CREATE FAIL");
    }

    $scope.getCompanyList();
}]);