# -*- coding: utf-8 -*-

module Quiz
  module V1
    class TrainScoreApi < BaseApi
      resource :train_scores do

        desc '获取用户成绩接口'
        params do
          optional :token, type: String, desc: "用户的唯一标识"
          optional :user_id, type: Integer, desc: "用户的id"
        end

        get '/' do
          parse_user_token
          result, content = Quiz::V1::TrainScoreService.user_train_score(params)
          if result
            render_json(data: content)
          else
            render_error(content)
          end
        end

        desc '成绩排名Top10接口'
        params do
          optional :token, type: String, desc: "用户的唯一标识"
        end

        get '/rank' do
          parse_user_token
          result, content = Quiz::V1::TrainScoreService.train_score_rank(params)
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