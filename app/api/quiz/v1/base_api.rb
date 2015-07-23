# -*- coding: utf-8 -*-

module Quiz
  module V1
    class BaseApi < Grape::API

      def self.inherited(subclass)
        super

        subclass.instance_eval do
          helpers Quiz::V1::Helpers
          #version 'v1'
          prefix 'quiz/v1'
        end
      end

    end
  end
end