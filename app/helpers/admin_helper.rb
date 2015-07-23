# -*- coding: utf-8 -*-

module AdminHelper

  def chinese_datetime(value)
    if value.present?
      value.strftime("%Y年%m月%d日 %H时:%M分:%S秒")
    end
  end

  def simple_today(value=Date.today)
    if value.present?
      value.strftime("%Y-%m-%d")
    else
      Date.today.strftime("%Y-%m-%d")
    end
  end

  def direct_delete_action(record)
    name = controller.controller_name
    url = "/admin/#{name}/#{record.id}"
    link_to('<img src="/assets/admin/shanchu.jpg">'.html_safe, "javascript:void(0)", onclick: "deleteResourceBtn('#{url}', #{record.id})", title: "删除")
  end

  def select_choices_for(objs)
    objs.map{|k,v| [k.to_s,v]}
  end

  def select_tag_options_for(objs, options={})
    choices = select_choices_for(objs)
    ret = []
    ret << "<option value="">#{options[:name]}</option>"
    ret << "<option value=""></option>"
    choices.each do |it|
      ret << "<option value='#{it[0]}' #{options[:selected]==it[0].to_s ? "selected" : nil} >#{it[1]}</option>"
    end
    ret.join(" ").html_safe
  end

  def question_status(status)
    case status
    when Question::ONLINE
      "<span class='label bg-success'>上线</span>".html_safe
    when Question::OFFLINE
      "<span class='label bg-default'>下线</span>".html_safe
    when Question::DELETED
      "<span class='label bg-danger'>删除</span>".html_safe
    end
  end

  def quiz_question_type(status)
    case status
    when Question::TRAIN
      "<span class='label bg-info'>训练</span>".html_safe
    when Question::CHANGE
      "<span class='label bg-default'>挑战</span>".html_safe
    when Question::INFERNO
      "<span class='label bg-danger'>地狱</span>".html_safe
    end
  end

  def question_option_link(id)
    url = "/admin/questions/question_manage_panel?question_id=#{id}"
    link_to("添加选项", "javascript:void(0)", onclick: "showQuestionOptionPanel('#{url}')", class: "label bg-info")
  end

  def active_topnav(names)
    name = controller.controller_name
    "active" if names.include?(name)
  end

  def question_controller_lists
    ['questions']
  end

  def question_option_controller_lists
    ['question_options']
  end

  def train_log_controller_lists
    ['train_logs']
  end

  def train_score_controller_lists
    ['train_scores']
  end

  def change_controller_lists
    ['changes']
  end

  def change_score_controller_lists
    ['change_scores']
  end

end





