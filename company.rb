# company.rb
require 'sinatra'
require 'sinatra/namespace'
require 'json'

namespace '/v1' do

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
	end

	$companies = {
		"1234567890" => Company.new("1234567890", 'Test Inc.', 'Test Street 1', 'Aarhus', 'Denmark', '555-9999'),
		"753159852" => Company.new("753159852", 'Nellictronix.', 'Best Way 2', 'Ankara', 'Turkey'),
	}

	get '/company' do
		cvr = params['cvr']
		if cvr
			getDetails(cvr)
		else 
			getAll()
		end		
	end

	post '/company' do
		request.body.rewind
		companyJson = JSON.parse(request.body.read)

		checkRequests(companyJson)
		newCompany = Company.new(companyJson['cvr'], companyJson['name'], companyJson['address'], companyJson['city'], companyJson['country'], companyJson['phone'])
		companies[newCompany.cvr] = newCompany
		return "Stored company with cvr: " << newCompany.cvr
	end

	def getAll()
		output = []
		$companies.each do |key, company|
			output << company.name
		end
		return output.to_json
	end

	def getDetails(cvr)
		company = $companies[cvr]
		if !company
			return 'Company with cvr = ' << cvr << ' not found.'
		end
		company.to_hash.to_json
	end

	def checkRequests(data)
		nonOptionalParameters = ['cvr', 'name', 'address', 'city', 'country']
		missingKeys = []

		nonOptionalParameters.each do |key|
			if !data.key?(key)
				missingKeys << key
			end
		end

		if !missingKeys.empty?
			return 'Invalid request. Missing keys: ' << missingKeys.join(',')
		end
	end
end