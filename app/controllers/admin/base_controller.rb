module Admin
  class BaseController < ActionController::Base
    layout 'admin'
    helper :admin
    protect_from_forgery
    # before_filter :authentication

    def parse_pagination
      @page = params[:page] || 1
      @per_page = params[:per_page] || 20
    end

    # def authentication
    #   if session[:username].present?
    #     @username = session[:username]
    #     return true
    #   else
    #     redirect_to root_path and return
    #   end
    # end

  end
end