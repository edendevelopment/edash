require File.dirname(__FILE__) + '/spec_helper'

describe EDash::ProgressReport do
  def create_report
    EDash::ProgressReport.new(%{[["a","4"],["b","6"],["c","10"]]})
  end
  context "when creating" do
    it "calculates the correct width for the progress report" do
      EDash::ProgressReport::Phase.should_receive(:new).with('a', 4, 20)
      EDash::ProgressReport::Phase.should_receive(:new).with('b', 6, 30)
      EDash::ProgressReport::Phase.should_receive(:new).with('c', 10, 50)
      create_report
    end
  end

  context "when retrieving the phases" do
    def retrieve_report
      report = create_report
      output = []
      report.each do |phase|
        output << phase
      end
    end

    it "returns a list of phases" do
      output = retrieve_report
      output[0].name.should == 'a'
      output[1].name.should == 'b'
      output[2].name.should == 'c'
    end

    it "width is adjusted as needed" do
      output = retrieve_report
      output[0].adjust_width_to(500).should == 100 
    end
  end
end
