class User < ActiveRecord::Base
  has_many :train_logs
  has_many :train_scores
end
