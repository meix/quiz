# -*- encoding : utf-8 -*-
module Admin
  class TrainLogsController < BaseController

    def index
      parse_pagination
      @search = TrainLog.ransack(params[:q])
      @records = @search.result.page(@page).order("created_at desc")
    end

    def show
      @record = TrainLog.find_by_id(params[:id])
    end

  end
end

