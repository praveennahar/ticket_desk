class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :authenticate_user!, unless: :devise_controller?

  def after_sign_in_path_for(_resource)
    trips_path
  end
end
