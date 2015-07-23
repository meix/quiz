$(function() {

  var LIMIT_COUNT = 50;

  var _slideIn = function (selector) {
    var element = $(selector);
    element.css({"visibility": "visible"});
    element.removeClass("animated").removeClass("slideOutUp");
    element.addClass("animated slideInUp");
  };

  var _slideOut = function (selector) {
    var element = $(selector);
    element.css({"visibility": "hidden"});
    element.removeClass("animated").removeClass("slideInUp");
    element.addClass("animated slideOutUp");
  };

  var Challenge = {

    isFetchingAnswer: false,

    isFetchingQuestion: false,

    init: function () {
      this.bindEvent();
    },

    bindEvent: function () {
      var form = $("#form-question");
      var buttons = $("div[jsaction=submit]", form);
      var next = $("#btn-next");
      buttons.on("tap", this.getAnswer);
      next.on('tap', this.getQuestion);
      next.on("click", function (evt) {
        evt.preventDefault();
        evt.stopPropagation();
        return false;
      });
    },

    getQuestionCBK: function (result) {
      $("#wrapper").html(result.html);
      $("#main").removeClass("right error limit");
      $("#main").addClass(
        result.limit_count && result.limit_count > LIMIT_COUNT ? "limit" : ""
      );
      if(result.at_last) {
        $(".widget-footer .finshed").show();
        $(".widget-footer .exit").hide();
        $(".widget-footer .next").hide();
      }
      _slideOut($(".widget-footer"));
      Challenge.init();
    },

    getAnswerCBK: function (result) {
      $("#wrapper").html(result.html);
      $("#main").removeClass("right error limit");
      $("#main").addClass(result.is_right ? "right" : "error");
      _slideIn($(".widget-footer"));
    },

    getQuestion: function (evt) {

      if(Challenge.isFetchingQuestion) {
        return;
      }
      Challenge.isFetchingQuestion = true;

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
          Challenge.isFetchingQuestion = false;
        },
        success: function(result, status, xhr) {
          Challenge.getQuestionCBK(result);
        },
        error: function(msg) {
          //
        }
      });
    },

    getAnswer: function (evt) {

      if(Challenge.isFetchingAnswer) {
        return;
      }
      Challenge.isFetchingAnswer = true;
      
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
          Challenge.isFetchingAnswer = false;
        },
        success: function(result, status, xhr) {
          Challenge.getAnswerCBK(result);
        },
        error: function(msg) {
          //
        }
      });
    }
  };

  window.Challenge = Challenge;

});
