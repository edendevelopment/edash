require File.dirname(__FILE__) + '/spec_helper'

describe 'Pivotal activity hook' do

  context 'reading xml' do
    context 'status: started' do
        subject { Pivotal::Progress.new(xml('started')) }
        its(:state) { should == 'started' }
    end

    context 'status: unstarted' do 
      subject { Pivotal::Progress.new(xml('unstarted')) }
      its(:state) { should == 'unstarted' }
    end

    context 'status: finshed' do 
      subject { Pivotal::Progress.new(xml('finished')) }
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

  context 'obtains project name from tracker' do
    subject { Pivotal::Project.new(project(0000, 'Foo Bar')) }
    its(:name) { should == 'Foo Bar' }

    def project(id, name)
      %Q{<?xml version="1.0" encoding="UTF-8"?>
          <project>
          <id>#{id}</id>
          <name>#{name}</name>
          <iteration_length type="integer">2</iteration_length>
          <week_start_day>Monday</week_start_day>
          <point_scale>0,1,2,3</point_scale>
          <account>James Kirks Account</account>
          <velocity_scheme>Average of 4 iterations</velocity_scheme>
          <current_velocity>10</current_velocity>
          <initial_velocity>10</initial_velocity>
          <number_of_done_iterations_to_show>12</number_of_done_iterations_to_show>
          <labels>shields,transporter</labels>
          <allow_attachments>true</allow_attachments>
          <public>false</public>
          <use_https>true</use_https>
          <bugs_and_chores_are_estimatable>false</bugs_and_chores_are_estimatable>
          <commit_mode>false</commit_mode>
          <last_activity_at type="datetime">2010/01/16 17:39:10 CST</last_activity_at>
          <memberships>
            <membership>
              <id>1006</id>
              <person>
                <email>kirkybaby@earth.ufp</email>
                <name>James T. Kirk</name>
                <initials>JTK</initials>
              </person>
              <role>Owner</role>
            </membership>
          </memberships>
          <integrations>
            <integration>
              <id type="integer">2</id>
              <type>Lighthouse</type>
              <name>Lighthouse Feature Bin</name>
              <field_name>lighthouse_id</field_name>
              <field_label>Lighthouse Id</field_label>
              <active>true</active>
            </integration>
            <integration>
              <id type="integer">2</id>
              <type>Lighthouse</type>
              <name>Lighthouse Bug Bin</name>
              <field_name>lighthouse_id</field_name>
              <field_label>Lighthouse Id</field_label>
              <active>false</active>
            </integration>
            <integration>
              <id type="integer">3</id>
              <type>Other</type>
              <name>United Federation of Planets Bug Tracker</name>
              <field_name>other_id</field_name>
              <field_label>United Federation of Planets Bug Tracker Id</field_label>
              <active>true</active>
            </integration>
          </integrations>
        </project>}
    end
  end
end
