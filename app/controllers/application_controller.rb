class ApplicationController < ActionController::API
  def get_page
    if params[:page] == "0"
      page = params[:page].to_i
    else
      page = (params.fetch(:page,1).to_i) - 1
    end
  end
  def get_per_page
    per_page = params.fetch(:per_page,20).to_i
  end
end
