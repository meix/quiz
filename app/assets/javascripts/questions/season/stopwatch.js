;(function($) {

  function MillisecondToDate(msd) {
    var time = parseFloat(msd) / 1000;
    var day = 0;
    var hour = 0;
    var minute = 0;
    var second = 0;
    if (null != time && "" != time) {
      if (time > 60 && time < 60 * 60) {
        minute = parseInt(time / 60.0);
        second = parseInt((parseFloat(time / 60.0) - parseInt(time / 60.0)) * 60);
      } else if (time >= 60 * 60 && time < 60 * 60 * 24) {
        hour    = parseInt(time / 3600.0);
        minute  = parseInt((parseFloat(time / 3600.0) -
                  parseInt(time / 3600.0)) * 60);
        second  = parseInt((parseFloat((parseFloat(time / 3600.0) - 
                  parseInt(time / 3600.0)) * 60) -
                  parseInt((parseFloat(time / 3600.0) - 
                  parseInt(time / 3600.0)) * 60)) * 60);
      } else if(time >= 60 * 60 * 24) {
        day = parseInt(time / (60 * 60 * 24));
      } else {
        second = parseInt(time);
      }
    }
    return {
      day: day,
      hour: hour,
      minute: minute,
      second: second
    };
  }


  //显示数字填补，即当显示的值为0-9时，在前面填补0;如：1:0:4, 则填补成为 01:00:04
  var format = function(arg) {
    return arg >= 10 ? ""+arg : "0" + arg;
  }

  var StopWatch = function(second) {
    var date = MillisecondToDate(second || 0);
    this.day = date.day;
    this.hour = date.hour;
    this.minute = date.minute;
    this.second = date.second;
    clearTimeout(this._timer);
  }

  StopWatch.prototype = {
    start: function(cbk) {
      var that = this;
      this._timer = setTimeout(function() {
        that.start(cbk);
      }, 1000);
      this.second++;
      if (this.second >= 60) {
        this.second = 0;
        this.minute++;
      }
      if (this.minute >= 60) {
        this.minute = 0;
        this.hour++;
      }
      cbk && cbk({
        hour: format(this.hour),
        minute: format(this.minute),
        second: format(this.second)
      });
    },
    now: function() {
      return {
        hour: format(this.hour),
        minute: format(this.minute),
        second: format(this.second)
      }
    },
    pause: function() {
      clearTimeout(this._timer);
    }
  };

  Quiz.StopWatch = StopWatch;

})(Zepto);
