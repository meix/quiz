# -*- encoding : utf-8 -*-

require 'spec_helper'

module Quiz
  module V1
    describe TrainApi do

      before(:each) do
        @question = create(:question)
        @option = create(:question_option)
        @user = create(:user)
        @user_token = create(:user_token)
      end

      describe "GET api /quiz/v1/trains/question" do
        it "should get trains question" do
          get "/quiz/v1/trains/question", token: @user_token.token
          response.status.should == 200
          resp_data = JSON.parse(response.body)
          resp_data["status"].should == "0000"
          resp_data["data"]["title"].should == @question.title
        end
      end

      describe "POST api /quiz/v1/trains/questions/:id" do
        it "should build train_log and train_score" do
          post "/quiz/v1/trains/questions/#{@question.id}", token: @user_token.token, answer: "A"
          response.status.should == 201
          resp_data = JSON.parse(response.body)
          resp_data["status"].should == "0000"
          resp_data["data"]["explain"].should == @question.explain
          resp_data["data"]["description"].should == @option.description
        end
      end

    end
  end
end