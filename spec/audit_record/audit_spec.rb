require "spec_helper"
require 'pry'

describe AuditRecord::Audit do
  describe "on create" do

    it "should call handle_audit" do
      a=AuditRecord::Audit.new
      AuditRecord.stub(:handle_audit)
      
      a.create

      expect(AuditRecord).to have_received(:handle_audit)
    end
  end
end
