class ApplicationController < ActionController::Base
  include Authentication
    helper :all # include all helpers, all the time
    protect_from_forgery # See ActionController::RequestForgeryProtection for details

    before_filter :set_locale

    def set_locale
      # if params[:locale] is nil then I18n.default_locale will be used
      I18n.locale = params[:locale]
    end

    # Scrub sensitive parameters from your log
    # filter_parameter_logging :password

    def default_url_options(options={})
      { :locale => I18n.locale }
    end
end
