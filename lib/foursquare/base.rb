module Foursquare
  class Base
    API = "https://api.foursquare.com/v2/"

    def initialize(access_token)
      @access_token = access_token
    end

    def users
      Foursquare::UserProxy.new(self)
    end

    def checkins
      Foursquare::CheckinProxy.new(self)
    end

    def venues
      Foursquare::VenueProxy.new(self)
    end

    def get(path, params={})
      Foursquare.log("GET #{API + path}")
      Foursquare.log("PARAMS: #{params.inspect}")
      params.merge!(:oauth_token => @access_token)
      response = JSON.parse(Typhoeus::Request.get(API + path, :params => params).body)
      Foursquare.log(response.inspect)
      response["meta"]["errorType"] ? error(response) : response["response"]
    end

    private

    def error(response)
      raise Foursquare::Error.new(Foursquare::ERRORS[response['meta']['errorType']])
    end
  end
end
