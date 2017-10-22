# restcompany

## Heroku

This repository is linked with Heroku and available at https://pure-river-43052.herokuapp.com/

## API

The API is versioned in the URL and is currently at /v1.
The API exposes three services: 
* GET /company - Returns a list of all companies
	* eg. 'curl -i https://pure-river-43052.herokuapp.com/v1/company' => HTTP 200

* GET /company/{cvr} - Returns details of company with cvr = {cvr}
	* eg. 'curl -i https://pure-river-43052.herokuapp.com/v1/company/12345674890' => HTTP 200
	* eg. 'curl -i https://pure-river-43052.herokuapp.com/v1/company/NONEXISTINGCVR' => HTTP 404

* POST /company - Adds a new company with the included data. Takes a json object with the fields: name, cvr, address, city, country and phone. phone is optional
	* eg. without phone - 'curl -i https://pure-river-43052.herokuapp.com -H "Content-Type: application/json" -X POST -d '{"cvr":"123", "name":"Test Company", "address": "Test Street", "city": "Test City", "country": "Test Country"}' => HTTP 204
	* eg. with phone - 'curl -i https://pure-river-43052.herokuapp.com -H "Content-Type: application/json" -X POST -d '{"cvr":"123", "name":"Test Company", "address": "Test Street", "city": "Test City", "country": "Test Country", "phone": "555-5555"}' => HTTP 204
	* eg. without cvr - 'curl -i https://pure-river-43052.herokuapp.com -H "Content-Type: application/json" -X POST -d '{"name":"Test Company", "address": "Test Street", "city": "Test City", "country": "Test Country", "phone": "555-5555"}' => HTTP 400


## CLIENT
Client is build in AngularJS and Bootstrap and available here https://pure-river-43052.herokuapp.com/

The client consists of:
* A list of all companies including a button to refresh it. Clicking the button will call GET '/company'.
	* Clicking a company in the list will call GET /company/{cvr} and show the details for that company.

* A form where company details can be input. If all non-optional fields are filled and the 'Submit company'-button is pressed the data is included when calling POST /company.
	* If the call is successful the list of companies is refreshed and details for the new company shown.


## QUESTIONS

### Authentication
Depending how sensitive the data being exposed and exchanged was I would use username/password authentication together with JWT or if data was more sensitive one could use to-way SSL authentication perhaps even with whitelisting of IP addresses. The advantage of the the first solution is that it can be implemented so that it does not require any manual setup by the provider of the service and very little on the part of the user (an account must be created).
Using two-way SSL authentication requires the much more setup possibly from both the provider and the user depending on how it is implemented.

### Redundancy
I would make use of Docker and run multiple instances of the service in containers making it easy. Having multiple servers each running multiple instances of the service would make the service resilient to problems arising in the service and in the server running the containers as well as making the service easily scalable. Making use of NoSQL database would facilitate this approach being used at the database level as well.

### Versioning of business data
I understand the question as relating to the storing of versioned data in a database (not versioning of the API and thereby the exposed data model)
If using a NoSQL database it would be quite easy to add a version to the key of the data object being stored. When accessing user number 147 moving from version 1 to version 2 the system would simple lookup 147_v2 instead of 147_v1. Depending on the changes from version 1 to 2 (and on the format of the data object) it might be possible to simply store the diff between the two versions avoiding redundant data.

Consercing the exposed data model one could use content-negotiation (as an alternative to URI versioning) to allow the client to select which version of the data should be returned (and thereby the version of the API).

### Search
From a backend point of view I would setup an Apache Solr server indexing the data and making it searchable through specific indexes. The search service could either access the Solr search engine directly or a web service could be put up in front of it in order to hide the implementation details.