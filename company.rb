# company.rb
require 'sinatra'
require 'sinatra/namespace'
require 'json'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

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

		def to_hash_short
			{
				:cvr => @cvr, 
				:name => @name
			}
		end
	end

	$companies = {
		"1234567890" => Company.new("1234567890", 'Test Inc.', 'Test Street 1', 'Aarhus', 'Denmark', '555-9999'),
		"753159852" => Company.new("753159852", 'Nellictronix.', 'Best Way 2', 'Ankara', 'Turkey'),
	}

	get '/company' do
		output = []
		$companies.each do |key, company|
			output << company.to_hash_short
		end
		output.to_json
	end

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

	post '/company' do
		request.body.rewind
		companyJson = JSON.parse(request.body.read)

		if !checkRequests(companyJson)
			return
		end
		newCompany = Company.new(companyJson['cvr'], companyJson['name'], companyJson['address'], companyJson['city'], companyJson['country'], companyJson['phone'])
		$companies[newCompany.cvr] = newCompany
		status 204
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
			status 400
			body 'Bad request. Missing keys: ' << missingKeys.join(',')
			return false
		end
		return true
	end
end