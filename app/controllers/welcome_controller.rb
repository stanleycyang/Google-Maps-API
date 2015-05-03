class WelcomeController < ApplicationController
  def maps
    url = 'https://maps.googleapis.com/maps/api/js?key='
    key = ENV['GOOGLE_MAPS']
    @endpoint = url + key
  end
end
