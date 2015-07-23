// 题目选项弹出框
function showQuestionOptionPanel(url){
  $.ajax({
    url: url,
    type: 'GET',
    success: function(result) {
      $("#questionPanel").html(result);
      $("#questionDialog").show();
    },
    error:function(response){
      var error_message = (response.status == 403) ? response.responseText : "程序处理异常，请稍后重试";
      alert(error_message);
    }
  });
  return false;
}

// Element is Empty
function isEmpty( el ){
  return !$.trim(el.html())
}

// 隐藏弹窗窗口
function hiddenDialog(dialog_id){
  $("#"+dialog_id).hide();
  return false;
}

// 点击删除按钮，直接删除
function deleteResourceBtn(url, id){
  if(confirm("确定删除吗?")){
    $.ajax({
      url: url,
      type: 'DELETE',
      success: function(result) {
        $("#record_"+id).hide('slow');
      },
      error:function(response){
        var error_message = (response.status == 403) ? response.responseText : "程序处理异常，请稍后重试";
        alert(error_message);
      }
    });
  }
  return false;
}


