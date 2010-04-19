require File.dirname(__FILE__) + '/spec_helper'

describe 'Pivotal activity hook' do

  context 'reading xml' do
    context 'status: started' do
        subject { PivotalProgress.new(xml('started')) }
        its(:state) { should == 'started' }
    end

    context 'status: unstarted' do 
      subject { PivotalProgress.new(xml('unstarted')) }
      its(:state) { should == 'unstarted' }
    end

    context 'status: finshed' do 
      subject { PivotalProgress.new(xml('finished')) }
      its(:state) { should == 'finished' }
    end
  end

  def xml(status)
    %Q{<?xml version="1.0" encoding="UTF-8"?>
      <activity>
        <id type="integer">0000000</id>
        <version type="integer">5</version>
        <event_type>story_update</event_type>
        <occurred_at type="datetime">2010/04/18 23:57:20 UTC</occurred_at>
        <author>Enrique Comba Riepenhausen and Gustin Prudner</author>
        <project_id type="integer">00000</project_id>
        <description>They are such awesome devs!</description>
        <stories>
          <story>
            <id type="integer">3201272</id>
            <url>http://www.pivotaltracker.com/services/v3/projects/00000/stories/00000</url>
            <current_state>#{status}</current_state>
          </story>
        </stories>
      </activity>}
  end
end


