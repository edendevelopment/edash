require File.dirname(__FILE__) + '/spec_helper'
require 'harmony'

describe 'queue.js' do
  let(:page) { Harmony::Page.new }
  before     { page.load('public/javascripts/queue.js') }
  it "pushes a new object onto the queue" do
    page.execute_js(<<-JS)
      queue = new Queue();
      queue.push('foo');
    JS
    page.execute_js('queue.length()').should == 1
  end

  it "runs the given function on anything passed into the queue" do
    page.execute_js(<<-JS)
      function addBar(hash) { hash['foo'] = 'baz'; }
      queue = new Queue(addBar);
      myObject = {'foo':'bar'};
      queue.push(myObject);
      queue.process();
    JS
    page.execute_js('myObject["foo"]').should == 'baz'
  end

  context "#schedule" do
    it "calls the passed in schedule function with the parameter" do
      page.execute_js(<<-JS)
        var calledWith = null;
        function scheduleFunc(param) { calledWith = param; }
        queue = new Queue(function(){}, scheduleFunc);
        queue.schedule('foo');
      JS
      page.execute_js('calledWith').should == 'foo'
    end
  end
end 
