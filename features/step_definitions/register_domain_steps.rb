When(/^I register a domain that is still available$/) do
  client.expect :create, 'domain/create_response'.epp, [EPP::Domain::Create]

  EPP::Client.stub :new, client do
    post orders_path, 'domain/create_request'.json
  end
end

Then(/^domain must be registered$/) do
  json_response.must_equal 'domain/create_response'.json
end


When(/^I register a domain with no domain name$/) do
  request = 'domain/create_request'.json
  request[:order_details][0][:domain] = ''
  post orders_path, request
end

When(/^I register a domain with no period$/) do
  request = 'domain/create_request'.json
  request[:order_details][0][:domain] = 'domainph'
  post orders_path, request
end

When(/^I register a domain with no registrant handle$/) do
  request = 'domain/create_request'.json
  request[:order_details][0][:registrant_handle] = ''
  post orders_path, request
end

When(/^I register a domain with no authcode$/) do
  request = 'domain/create_request'.json
  request[:order_details][0][:authcode] = ''
  post orders_path, request
end

When(/^I register a domain with existing domain name$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I register a domain with period more than (\d+) years$/) do |period|
  request = 'domain/create_request'.json
  request[:order_details][0][:period] = (period.to_i+1).to_s
  post orders_path, request
end

When(/^I register a domain with non\-existing registrant handle$/) do
  pending # express the regexp above with the code you wish you had
end