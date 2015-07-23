# -*- encoding : utf-8 -*-

module Admin
  class QuestionOptionsController < BaseController

    def index
      parse_pagination
      @search = QuestionOption.ransack(params[:q])
      @records = @search.result.page(@page).order("question_id")
    end

    def new
      @record = QuestionOption.new
    end

    def show
      @record = QuestionOption.find_by_id(params[:id])
    end

    def edit
      @record = QuestionOption.find_by_id(params[:id])
    end

    def update
      @record = QuestionOption.find_by_id(params[:id])
      if @record
        if @record.refresh_question_option(protect_params)
        end
      end
      render action: 'show'
    end

    def create
      @record = QuestionOption.build_question_option(protect_params)
      if @record.valid?
        render action: 'show'
      else
        render action: 'new'
      end
    end

    def destroy
      QuestionOption.delete_question_option(params[:id])
      render text: 'success' and return
    end

    def add_question_option
      QuestionOption.build_question_option(params)
      @records = QuestionOption.where(question_id: params[:question_id])
      render partial: 'option_list', locals: {records: @records}
    end

    private
      def protect_params
        params.require(:question_option).permit(:question_id, :description, :ordinal)
      end
  end
end