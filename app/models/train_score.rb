# == Schema Information
#
# Table name: train_scores
#
#  id                :integer
#  user_id          :integer,  null: false
#  ratio            :decimal, precision: 3, scale: 2, default: 0
#  right_times     :integer, default: 0
#  diamond          :integer, default: 0
#  end_at          :datetime
#  spend             :integer, default: 0
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  train_logs, :user_id, unique: true

class TrainScore < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :ratio, :diamond, :right_times, presence: true

  def set_params(params)
    self.user_id = params[:user_id] if params[:user_id].present?
    self.diamond = params[:diamond] if params[:diamond].present?
    self.ratio = params[:ratio] if params[:ratio].present?
    self.right_times = params[:right_times] if params[:right_times].present?
    self.end_at = params[:end_at] if params[:end_at].present?
    self.spend = params[:spend] if params[:spend].present?
  end

  def refresh_train_score(params)
    self.set_params(params)
    self.save
  end

  class << self

    def build_train_score(params)
      record = TrainScore.new
      record.set_params(params)
      record.save
      record
    end

    def fetch_by_user(user_id)
      where(user_id: user_id).first
    end

    def user_train_score(record)
      train_score = fetch_by_user(record.user_id)
      if train_score.present?

        train_logs = TrainLog.where(user_id: record.user_id).all
        diamond = train_logs.inject(0){ |sum, train_log| sum + train_log.diamond.to_i }
        right_times = train_logs.inject(0){ |sum, train_log| sum + train_log.right_times.to_i }
        total_times = train_logs.inject(0){ |sum, train_log| sum + train_log.total_times.to_i }

        train_score.refresh_train_score(train_user_log_params(record.user_id, diamond, right_times, total_times))
      else
        TrainScore.build_train_score(train_user_log_params(record.user_id, record.diamond,
                                        record.right_times, record.total_times  ))
      end
    end

    def train_user_log_params(user_id, diamond, right_times, total_times )
      user_id = user_id
      diamond = diamond
      right_times = right_times
      total_times = total_times
      ratio = format("%.2f",right_times.to_f/total_times.to_f).to_f
      {user_id: user_id, diamond: diamond, right_times: right_times,
            ratio: ratio, end_at: Time.now }
    end

    def get_user_score(user_id)
      fetch_by_user(user_id)
    end

    def score_rank(user_id)
      @user_score = fetch_by_user(user_id)
      @scores = TrainScore.order("diamond desc, ratio desc, end_at asc")
      @train_scores = @scores.limit(10)
      @user_score_info = {}
      @train_scores.each_with_index do |train_score, index|
        @ranking = index + 1 if user_id == train_score.user_id
      end
      @ranking ||= TrainScore.where("diamond >= ?", @user_score.try(:diamond).to_i).count + 1
      ret = {train_scores: @train_scores, user_score: @user_score, ranking: @ranking}
    end

  end

end
