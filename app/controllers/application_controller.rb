class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :signed_in?, :is_current_user?
  before_filter { |controller| session[:restore_url] = request.url if controller.controller_name != "sessions" && !request.xhr? }

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to ENV["MEURIO_ACCOUNTS_URL"] + "?redirect_url=#{session[:restore_url]}"
  end

  # This is how you can sign in on the development environment
  before_filter { session[:ssi_user_id] = params[:sign_in] if Rails.env.development? && params[:sign_in] }

  before_filter :require_authentication

  def require_authentication
    puts session['cas'].inspect
    render(text: 'You shall not pass!', status: :unauthorized, layout: false) if request.session['cas'].nil?
  end

  protected
  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def current_user
    @current_user ||= User.find_by_id(session[:ssi_user_id])
  end

  def is_current_user?(user)
    current_user == user
  end

  def signed_in?
    !!current_user
  end

  def require_facebook_auth
    return redirect_to "/auth/facebook"
  end

  def require_twitter_auth
    return redirect_to "/auth/twitter"
  end

  private
  def current_ability
    @current_ability ||= Ability.new(current_user, request)
  end
end
