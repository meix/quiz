# -*- encoding : utf-8 -*-

module Quiz
  module V1
    class TrainService

      class << self

        def get_train_question(params)
          current_user_id = params[:current_user_id]
          question_ids = Question.get_train_question(current_user_id)
          if question_ids.present?
            @question = Question.where(id: question_ids.sample.to_i).first
            [@question, Quiz::V1::TrainWrapper.train_question_info(@question, question_ids)]
          else
            ErrorCode.error_content(:question_not_existed)
          end
        end

        def verify_option(params)
          current_user_id = params[:current_user_id]
          @result = Question.verify_option(current_user_id, params[:id], params[:answer])
          if @result.present?
            [@result, Quiz::V1::TrainWrapper.answer_results(@result)]
          else
            ErrorCode.error_content(:invalid_parameters)
          end
        end

      end

    end
  end
end