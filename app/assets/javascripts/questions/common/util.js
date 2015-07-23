// boohee util
(function($) {
  $.fn.serializeHash = function () {
    var data = {};
    var serializeArray = this.serializeArray();
    $.each(serializeArray, function(key, item) {
      data[item.name] = item.value;
    });
    return data;
  };
})($);
