# == Schema Information
#
# Table name: train_logs
#
#  id                :integer
#  user_id          :integer
#  question_id     :integer
#  total_times     :integer, default: 0
#  right_times     :integer, default: 0
#  diamond   :integer, default: 0
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  train_logs, [:user_id, :question_id], unique: true
#

class TrainLog < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :question_id, :diamond, :total_times, :right_times, presence: true

  def set_params(params)
    self.user_id = params[:user_id] if params[:user_id].present?
    self.question_id = params[:question_id] if params[:question_id].present?
    self.diamond = params[:diamond] if params[:diamond].present?
    self.total_times = params[:total_times] if params[:total_times].present?
    self.right_times = params[:right_times] if params[:right_times].present?
  end

  def refresh_train_log(params)
    TrainLog.transaction do
      self.set_params(params)
      self.save
      TrainScore.user_train_score(self)
    end
  end

  class << self

    def right_question(current_user_id)
      where("user_id = ? AND right_times = ?", current_user_id, 1).all
    end

    def build_train_log(params)
      record = TrainLog.new
      TrainLog.transaction do
        record.set_params(params)
        record.save
        TrainScore.user_train_score(record)
      end
      record
    end

    def user_train_log(user_id, question, answer)
      train_log = where(user_id: user_id, question_id: question.id ).first
      if train_log.present?
        log_existed(user_id, question, train_log, answer)
      else
        log_not_exsited(user_id, question, answer)
      end
    end

    def log_existed(user_id, question, train_log, answer)
     ret = verify_option_result(question.answer, QuestionOption.option_description(question.id, answer), question.explain)
      # 当选项与题目正确答案相等时
      if question.answer == answer
        train_log.total_times += 1
        train_log.right_times += 1
        ret[:diamond] = question.level.to_i * 5
        ret[:is_right] = true
        train_log.diamond = train_log.diamond + question.level.to_i * 5
      else
        train_log.total_times += 1
        train_log.right_times = 0
        diamond = 0
      end
      # 刷新创建用户的答题纪录
      train_log.refresh_train_log(train_log_params(user_id, question.id, train_log.total_times,
          train_log.right_times, train_log.diamond))  if train_log.right_times <= 1
      ret
    end

    def log_not_exsited(user_id, question, answer)
      ret = verify_option_result(question.answer, QuestionOption.option_description(question.id, answer), question.explain)
      if question.answer == answer
        total_times = 1
        right_times = 1
        ret[:diamond] = question.level.to_i * 5
        ret[:is_right] = true
        diamond = question.level.to_i * 5
      else
        total_times = 1
        right_times = 0
        diamond = 0
      end
      build_train_log(train_log_params(user_id, question.id, total_times, right_times, diamond))
      ret
    end

    def train_log_params(user_id, question_id, total_times, right_times, diamond)
       { user_id: user_id,
         question_id: question_id,
         total_times: total_times,
         right_times: right_times,
         diamond: diamond
       }
    end

    def verify_option_result(answer, description, explain)
      ret = {diamond: nil, description:"", answer:"" ,explain:"", is_right: false}
      ret[:answer] = answer
      ret[:description] = description
      ret[:explain] = explain
      ret
    end

  end

end
