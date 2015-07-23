# -*- encoding : utf-8 -*-

require 'spec_helper'

module Quiz
  module V1
    describe TrainScoreApi do

      before(:each) do
        @user = create(:user)
        @user_token = create(:user_token)
        @score = create(:train_score)
      end

      describe "GET api /quiz/v1/train_scores" do
        it "should get user score" do
          get "/quiz/v1/train_scores", token: @user_token.token, user_id: @user.id
          response.status.should == 200
          resp_data = JSON.parse(response.body)
          resp_data["status"].should == "0000"
          resp_data["data"]["nick_name"].should == @user.nick_name
          resp_data["data"]["diamond"].should == @score.diamond
        end
      end

      describe "GET api /quiz/v1/train_scores/rake" do
        it "should get user score Top10" do
          get "/quiz/v1/train_scores/rake", token: @user_token.token
          response.status.should == 200
          resp_data = JSON.parse(response.body)
          resp_data["status"].should == "0000"
          resp_data["data"]["top_10"][0]["diamond"].should == @score.diamond
        end
      end

    end
  end
end