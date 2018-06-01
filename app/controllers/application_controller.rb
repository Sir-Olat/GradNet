class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?


  def after_sign_in_path_for(resource)
     request.env['omniauth.origin'] || discussions_path
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :date_of_birth, :gender])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :address, :date_of_birth, :gender, :field_of_expertise, :bio, :course_studied, :work_place, :year_of_graduation, :slug, :profile_picture])

  end

end


