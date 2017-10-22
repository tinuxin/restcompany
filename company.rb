# company.rb
require 'sinatra'
require 'sinatra/namespace'
require 'json'

# Serve static client
get '/' do
	send_file File.join(settings.public_folder, 'index.html')
end

# URI versioning is used in place of eg. content-negotiation.
namespace '/v1' do

	# Storage for the companies. Takes the place of a database or other persistent storage.
	$companies = {}

	# Data model for a company
	class Company
		attr_reader :cvr, :name, :address, :city, :country, :phone

		def initialize(cvr, name, address, city, country, phone=nil)
			@cvr = cvr
			@name = name
			@address = address
			@city = city
			@country = country
			@phone = phone
		end

		# Returns all the fields of the company in hash format.
		def to_hash
			{
				:cvr => @cvr, 
				:name => @name, 
				:address => @address, 
				:city => @city, 
				:country => @country, 
				:phone => @phone
			}
		end

		# Returns the company in hash format - including only name and cvr for display and lookup purposes.
		def to_hash_short
			{
				:cvr => @cvr, 
				:name => @name
			}
		end
	end

	# Resource to get a list of the all stored companies
	get '/company' do
		output = []
		$companies.each do |key, company|
			output << company.to_hash_short
		end
		output.to_json
	end

	# Resource to get the details of a company with the given cvr.
	get '/company/:cvr' do
		cvr = params['cvr']
		company = $companies[cvr]
		if !company
			status 404
			body 'Company with cvr = ' << cvr << ' not found.'
		else
			company.to_hash.to_json
		end	
	end

	# Resource to store a company using the included data.
	post '/company' do
		request.body.rewind
		companyJson = JSON.parse(request.body.read)

		if !isValidRequest(companyJson)
			return
		end
		newCompany = Company.new(companyJson['cvr'], companyJson['name'], companyJson['address'], companyJson['city'], companyJson['country'], companyJson['phone'])
		$companies[newCompany.cvr] = newCompany
		status 204
		body "Company sucessfully created"
	end

	# Checks if a request to store a company is valid and if not sets the error message enumerating the missing values.
	def isValidRequest(data)
		nonOptionalParameters = ['cvr', 'name', 'address', 'city', 'country']
		missingKeys = []

		nonOptionalParameters.each do |key|
			if !data.key?(key)
				missingKeys << key
			end
		end

		if !missingKeys.empty?
			status 400
			body 'Bad request. Missing keys: ' << missingKeys.join(',')
			return false
		end
		return true
	end
end