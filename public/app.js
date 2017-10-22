var restcompany = angular.module('restcompany', []);

restcompany.controller('mainController', ['$scope', '$http', 
    function ($scope, $http) {
    
    // Data model
    $scope.companies=[];
    $scope.companyDetails;

    // Form data model
    $scope.name;
    $scope.cvr;
    $scope.address;
    $scope.city;
    $scope.country;
    $scope.phone;

    // Get the company details via http
    $scope.getCompanyDetails = function (cvr) {
        $http.get('/v1/company/'+cvr, {}).then($scope.companyDetailsSucceeded, $scope.companyDetailsFailed);
    }

    // Handle getting company details - set the data in the model.
    $scope.companyDetailsSucceeded = function(response) {
        $scope.companyDetails=response.data;
    }

    // Simply alert user when getting company details failed.
    $scope.companyDetailsFailed = function(response) {
        alert("DETAILS FAIL: "+JSON.stringify(response));
    }

    // Get the list companies via http
    $scope.getCompanyList = function () {
        $http.get('/v1/company').then($scope.companyListSuceeded, $scope.companyListFailed);
    }

    // Handle getting list of companies - set the data in the model.
    $scope.companyListSuceeded = function(response) {
        $scope.companies=response.data;
    }

    // Simply alert user when getting list of companies failed.
    $scope.companyListFailed = function(response) {
        alert("LIST FAIL: "+JSON.stringify(response));
    }

    // Post the content of the form data model via http
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

    // Handle a new company bering created, refreshing list of companies, retrieve details of new company and reset form data model.
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

    // Simply alert user when creating company failed. 
    $scope.companyCreateFailed = function(response) {
        alert("CREATE FAIL: "+JSON.stringify(response));
    }

    $scope.getCompanyList();
}]);