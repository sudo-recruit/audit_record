require "spec_helper"
require 'pry'

describe RecordAuditor::Audit do
  describe "on create" do

    it "should call handle_audit" do
      a=RecordAuditor::Audit.new
      RecordAuditor.stub(:handle_audit)
      
      a.create

      expect(RecordAuditor).to have_received(:handle_audit)
    end
  end
end
