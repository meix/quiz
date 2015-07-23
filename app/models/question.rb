# -*- encoding : utf-8 -*-
#
# Table name: questions  频道
#
#  id            :integer
#  title        :string(255)    标题
#  answer       :string(255)    答案
#  category    :string(255)     标签
#  level        :integer        等级
#  explain     :string(255)     题目讲解
#  status      :integer         状态，0 为上线
#  quiz_type   :integer        挑战类型

class Question < ActiveRecord::Base
  has_many :question_options

  validates :title, :answer, :category, :level, :explain, :status, :quiz_type, presence: true

  ONLINE = 0
  OFFLINE = 1
  DELETED = 2
  STATUS_TYPES = {
    ONLINE => "上线",
    OFFLINE => "下线",
    DELETED => "删除"
  }

  TRAIN = 0
  CHANGE = 1
  INFERNO = 2
  QUIZ_TYPES = {
    TRAIN => "训练模式",
    CHANGE => "挑战模式",
    INFERNO => "地狱模式"
  }

  EXCEL_QUESTION_HEADER = {
    question_id:    '编号',
    title:           '题干',
    answer:          '答案',
    category:       '类型',
    level:           '难度',
    explain:        '解释'
  }

  def set_params(params)
    self.title = params[:title].lstrip if params[:title].present?
    self.answer = params[:answer].upcase if params[:answer].present?
    self.category = params[:category].lstrip if params[:category].present?
    self.level = params[:level] if params[:level].present?
    self.explain = params[:explain].lstrip if params[:explain].present?
    self.status = params[:status] if params[:status].present?
    self.quiz_type = params[:quiz_type] if params[:quiz_type].present?
  end

  def refresh_question(params)
    self.set_params(params)
    self.save
  end

  class << self

    def build_question(params)
      question = Question.new
      question.set_params(params)
      question.save
      question
    end

    def build_excel_import(question_id, title, answer, category, level, explain)
      question = Question.new
      question_params = {title: title, answer: answer, category: category, level: level, explain: explain }
      question.set_params(question_params)
      question.id = question_id
      question.save
      question
    end

    def delete_question(id)
      Question.transaction do
        question = Question.find_by_id(id)
        if question
          question.update_attributes(status: Question::DELETED)
        end
      end
    end

    def import(file)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        notices = {}
        begin
          question_id = row[EXCEL_QUESTION_HEADER[:question_id]]
          answer = row[EXCEL_QUESTION_HEADER[:answer]]
          category = row[EXCEL_QUESTION_HEADER[:category]]
          if category.present? && answer.present?
            title = row[EXCEL_QUESTION_HEADER[:title]]
            level = row[EXCEL_QUESTION_HEADER[:level]]
            explain = row[EXCEL_QUESTION_HEADER[:explain]]
            if title.present? || explain.present? || level.present?
              if title.present? && explain.present? && level.present?
                build_excel_import(question_id.to_i, title, answer, category, level, explain)
              else
                raise
              end
            else
              question_id = question_id
              description = answer
              ordinal = category
              question_option_params = {question_id: question_id.to_i, description: description, ordinal: ordinal } 
              question_option = QuestionOption.where(question_id: question_id, ordinal: ordinal ).first
              if question_option.present?
                raise
              else
                QuestionOption.build_question_option(question_option_params)
              end
            end
          else
            raise
          end
        rescue ActiveRecord::RecordNotUnique
          notices[:question_id] = question_id
          notices[:title] = title
          return notices
        rescue RuntimeError
          notices[:question_id] = question_id
          notices[:category] = category
          notices[:answer] = answer
          return notices
        end
      end
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, file_warning: :ignore)
      when ".xls" then Roo::Excelx.new(file.path, file_warning: :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end

    def fetch_by_id(id)
      where(id: id).first
    end


    def get_train_question(current_user_id)
      questions = Question.where(quiz_type: Question::TRAIN, status: Question::ONLINE).all
      train_logs = TrainLog.right_question(current_user_id)
      residue_question(questions, train_logs)
    end

    def residue_question(questions, train_logs)
      question_ids = questions.map{|question| question.id}
      train_log_ids = train_logs.map{|train_log| train_log.question_id }
      residue_question_ids = question_ids - train_log_ids
    end

    def verify_option(current_user_id, id, answer)
      question = fetch_by_id(id)
      if question.present?
        # API 接口需要返回的hash类型数据
        TrainLog.user_train_log(current_user_id, question, answer)
      end
    end

  end
end
