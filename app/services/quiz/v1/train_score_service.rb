# -*- encoding : utf-8 -*-

module Quiz
  module V1
    class TrainScoreService
      class << self

        def user_train_score(params)
          @score = TrainScore.get_user_score(params[:user_id])
          if @score.present?
            [@score, Quiz::V1::TrainScoreWrapper.user_score_info(@score)]
          else
            ErrorCode.error_content(:train_score_not_existed)
          end
        end

        def train_score_rank(params)
          current_user_id = params[:current_user_id]
          @records = TrainScore.score_rank(current_user_id)
          if @records.present?
            [@records, Quiz::V1::TrainScoreWrapper.rake_info(@records)]
          else
            ErrorCode.error_content(:train_score_not_existed)
          end
        end

      end
    end
  end
end