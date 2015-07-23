# -*- encoding : utf-8 -*-

module Quiz
  module V1
    class TrainWrapper < BaseWrapper

      class << self
        def train_question_info(question, question_ids)
          ret = { id: question.id, title: question.title, explain: question.explain }
          ret[:final] = question_ids.count == 1 ? true : false
          ret[:options] = Quiz::V1::QuestionOptionWrapper.question_option_info(question.question_options)
          ret
        end

        def answer_results(result)
          {
            diamond: result[:diamond],
            description: result[:description],
            answer: result[:answer] ,
            explain:result[:explain],
            is_right: result[:is_right]
          }
        end

      end

    end
  end
end