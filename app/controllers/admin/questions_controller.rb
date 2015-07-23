# -*- encoding : utf-8 -*-

module Admin
  class QuestionsController < BaseController

    def index
      parse_pagination
      @search = Question.ransack(params[:q])
      @search_count = @search.result.order("id")
      @records = @search.result.page(@page).order("id")
    end

    def new
      @record = Question.new
    end

    def show
      @record = Question.find_by_id(params[:id])
    end

    def edit
      @record = Question.find_by_id(params[:id])
    end

    def update
      @record = Question.find_by_id(params[:id])
      if @record
        if @record.refresh_question(protect_params)
        end
      end
      render action: 'show'
    end

    def create
      @record = Question.build_question(protect_params)
      if @record.valid?
        render action: 'show'
      else
        render action: 'new'
      end
    end

    def destroy
      Question.delete_question(params[:id])
      render text: 'success' and return
    end

    def question_manage_panel
      @question = Question.where(id: params[:question_id]).first
      @records = QuestionOption.where(question_id: @question.id)
      render partial: 'question_manage_panel', locals: {records: @records, question: @question}
    end

    def import
      error_messages = Question.import(params[:file])
      redirect_to action: 'index', notices: error_messages
    end

    private
      def protect_params
        params.require(:question).permit(:title, :answer, :category, :level, :explain, :status, :quiz_type)
      end
  end
end
