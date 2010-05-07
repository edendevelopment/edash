var emptyFunc = function(){};
function Queue(processFunction, scheduleFunction) {
  this._array = new Array();
  this._processFunction = processFunction;
  this._scheduleFunction = scheduleFunction || emptyFunc;

  this.push = function(item) {
    this._array.push(item);
  };
  this.next = function() {
    return this._array.shift();
  };
  this.length = function() {
    return this._array.length;
  };
  this.process = function() {
    if (this.length() == 0) { 
      scheduleFunction(1000);
      return; 
    }
    processFunction(this.next());
  };
  this.schedule = function(count) {
    scheduleFunction(count);
  };
};


