# restcompany

## Heroku

This repository is linked with Heroku and available at https://pure-river-43052.herokuapp.com/

## API

The API is versioned in the URL and is currently at /v1.
The API exposes three services: 
* GET /company - Returns a list of all companies
** eg. 'curl https://pure-river-43052.herokuapp.com/v1/company' - HTTP 200

* GET /company/{cvr} - Returns details of company with cvr = {cvr}
** eg. 'curl https://pure-river-43052.herokuapp.com/v1/company/12345674890' - HTTP 200
** eg. 'curl https://pure-river-43052.herokuapp.com/v1/company/NONEXISTINGCVR' - HTTP 404

* POST /company - Adds a new company with the included data. Takes a json object with the fields: name, cvr, address, city, country and phone. phone is optional
** eg. without phone - 'curl https://pure-river-43052.herokuapp.com -H "Content-Type: application/json" -X POST -d '{"cvr":"123", "name":"Test Company", "address": "Test Street", "city": "Test City", "country": "Test Country"}' - HTTP 204
** eg. with phone - 'curl https://pure-river-43052.herokuapp.com -H "Content-Type: application/json" -X POST -d '{"cvr":"123", "name":"Test Company", "address": "Test Street", "city": "Test City", "country": "Test Country", "phone": "555-5555"}' - HTTP 204
** eg. without cvr - 'curl https://pure-river-43052.herokuapp.com -H "Content-Type: application/json" -X POST -d '{"name":"Test Company", "address": "Test Street", "city": "Test City", "country": "Test Country", "phone": "555-5555"}' - HTTP 400



## CLIENT
Client is build in AngularJS and Bootstrap and available here https://pure-river-43052.herokuapp.com/

The client consists of:
* A list of all companies including a button to refresh it. Clicking the button will call GET '/company'.
** Clicking a company in the list will call GET /company/{cvr} and show the details for that company.

* A form where company details can be input. If all non-optional fields are filled and the 'Submit company'-button is pressed the data is included when calling POST /company.
** If the call is successful the list of companies is refreshed and details for the new company shown.