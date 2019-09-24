class ApplicationController < ActionController::Base
  def home
    render 'home/display'
  end
end
