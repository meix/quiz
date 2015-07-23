# -*- encoding : utf-8 -*-
#
# Table name: question_options  频道
#
#  id              :integer
#  question_id   :string(255)    所属题目ID
#  description   :string(255)    选项内容
#  ordinal         :string(255)   序号

class QuestionOption < ActiveRecord::Base
  belongs_to :question
  validates :question_id, :description, :ordinal, presence: true

  def set_params(params)
    self.question_id = params[:question_id] if params[:question_id].present?
    self.description = params[:description] if params[:description].present?
    self.ordinal = params[:ordinal].upcase if params[:ordinal].present?
  end

  def refresh_question_option(params)
    self.set_params(params)
    self.save
  end

  class << self

    def build_question_option(params)
      question_option = QuestionOption.new
      question_option.set_params(params)
      question_option.save
      question_option
    end

    def delete_question_option(id)
      QuestionOption.where(id: id).delete_all
    end

    def option_description(question_id, answer)
      question_option = where(question_id: question_id, ordinal: answer ).first
      if question_option.present?
        description = question_option.description
      else
        description = "该题目无选项"
      end
    end

  end

end
