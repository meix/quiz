# -*- coding: utf-8 -*-

module Quiz
  module V1
    class TrainApi < BaseApi
      resource :trains do

        desc '获取题目接口'
        params do
          optional :token, type: String, desc: "用户的唯一标识"
        end

        get '/question' do
          parse_user_token
          result, content = Quiz::V1::TrainService.get_train_question(params)
          if result
            render_json(data: content)
          else
            render_error(content)
          end
        end

        desc '验证选项答案接口'
        params do
          optional :token, type: String, desc: "用户的唯一标识"
          optional :answer, type: String, desc: "用户选择答案"
        end

        post '/questions/:id' do
          validate_user_token
          result, content = Quiz::V1::TrainService.verify_option(params)
          if result
            render_json(data: content)
          else
            render_error(content)
          end
        end

      end
    end
  end
end