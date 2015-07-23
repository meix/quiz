# -*- coding: utf-8 -*-

module Quiz
  module V1
    module Apis

      def self.included(api)
        api.mount Quiz::V1::QuestionApi
        api.mount Quiz::V1::TrainApi
        api.mount Quiz::V1::TrainScoreApi
      end

    end
  end
end
