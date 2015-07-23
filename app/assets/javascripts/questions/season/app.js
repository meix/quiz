$(function() {

  var Season = {

    isFetchingAnswer: false,

    isFetchingQuestion: false,

    init: function () {
      this._init();
      var time = $("#time");
      new Quiz.StopWatch().start(function (date) {
        time.html(date.minute+":"+date.second);
      });
    },

    _init: function () {
      this.bindEvent();
      this._timer && window.clearInterval(this._timer);
    },

    bindEvent: function () {
      var form = $("#form-question");
      var buttons = $("div[jsaction=submit]", form);
      buttons.on("tap", this.getAnswer);
    },

    getQuestionCBK: function (result) {
      $("#wrapper").html(result.html);
      $("#quiz_index").html(result.quiz_index);
      $("#quiz_count").html(result.quiz_count);
      Season._init();
    },

    getAnswerCBK: function (result) {
      $("#wrapper").html(result.html);
      var btn_next = $("#btn-next");
      var btn_submit = $("#btn-submit");
      var countdown = $("#countdown");
      var number = 5;
      btn_next.on("tap", this.getQuestion);
      btn_next.on("click", function (evt) {
        evt.preventDefault();
        evt.stopPropagation();
        return false;
      });
      this._timer && window.clearInterval(this._timer);
      this._timer = window.setInterval(function () {
        number--;
        if(number==0) {
          btn_next && btn_next.trigger("tap");
          btn_submit && btn_submit.trigger("click");
          window.clearInterval(this._timer);
          return;
        }
        countdown.html("("+number+"秒)");
      }, 1000);
    },

    getQuestion: function (evt) {
      
      this._timer && window.clearInterval(this._timer);

      if(Season.isFetchingQuestion) {
        return;
      }
      Season.isFetchingQuestion = true;

      var target = $(this);
      $.ajax({
        // 这里必须要加上额外的参数防止浏览器后退渲染pagelet页面 by jican
        url: this.href+"&t="+Date.now(),
        type: "GET",
        dataType: "json",
        beforeSend: function(xhr) {
          xhr.setRequestHeader('RenderType', 'pagelet');
        },
        complete: function () {
          Season.isFetchingQuestion = false;
        },
        success: function(result, status, xhr) {
          Season.getQuestionCBK(result);
        },
        error: function(msg) {
          //
        }
      });
    },

    getAnswer: function (evt) {

      if(Season.isFetchingAnswer) {
        return;
      }
      Season.isFetchingAnswer = true;
      
      var target = $(this);
      var form = $("#form-question");
      var token = $("input[name='authenticity_token']", form).val() || "";
      var ordinal = $("#ordinal").val(target.attr("data-ordinal"));
      var postData = form.serializeHash();

      $.ajax({
        url: form[0].action,
        type: "POST",
        dataType: "json",
        data: postData,
        beforeSend: function(xhr) {
          xhr.setRequestHeader('RenderType', 'pagelet');
        },
        complete: function () {
          Season.isFetchingAnswer = false;
        },
        success: function(result, status, xhr) {
          Season.getAnswerCBK(result);
        },
        error: function(msg) {
          //
        }
      });
    }
  };

  Quiz.Season = Season;

});
