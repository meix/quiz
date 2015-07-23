# -*- encoding : utf-8 -*-
module Admin
  class TrainScoresController < BaseController

    def index
      parse_pagination
      @search = TrainScore.ransack(params[:q])
      @records = @search.result.page(@page).order("diamond desc, ratio desc, end_at asc")
    end

    def show
      @record = TrainScore.find_by_id(params[:id])
    end

  end
end
