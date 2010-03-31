require File.dirname(__FILE__) + '/spec_helper'
require 'harmony'

describe 'index.haml' do
  context 'replacing build with queued version' do
    let(:page) { Harmony::Page.new }
    before do
      page.load('public/javascripts/effects.js')
    end
  end
end 
