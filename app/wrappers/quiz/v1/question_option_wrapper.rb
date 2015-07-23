# -*- encoding : utf-8 -*-

module Quiz
  module V1
    class QuestionOptionWrapper < BaseWrapper

      class << self

        def question_option_info(question_options)
          question_options.each do |option|
            {question_id: option.question_id, description: option.description, ordinal: option.ordinal}
          end
        end

      end

    end
  end
end