class ApplicationController < ActionController::Base
  include QuestionsHelper
  
  protect_from_forgery
end
