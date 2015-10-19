require "spec_helper"
require 'pry'

describe AuditRecord::Auditor do
  describe "on create" do
    let( :user ) { build_user}

    it "should call audit_create" do
      user.stub(:audit_create)

      user.save

      expect(user).to have_received(:audit_create)
    end

    it "should call handle_audit with correct arguments" do
      user.stub(:handle_audit)

      user.save

      audited_attributes={"name"=> 'darth', "username"=> 'darth',"activated"=>nil, "suspended_at"=>nil, "logins"=>0}
      expect(user).to have_received(:handle_audit).with(action: 'create', audited_changes: audited_attributes)
    end

    # it "should not audit an attribute which is excepted if specified on create or destroy" do
    #   on_create_destroy_except_name = Models::ActiveRecord::OnCreateDestroyExceptName.create(:name => 'Bart')
    #   expect(on_create_destroy_except_name.audits.first.audited_changes.keys.any?{|col| ['name'].include? col}).to eq(false)
    # end

    # it "should not save an audit if only specified on update/destroy" do
    #   # expect {
    #   #   Models::ActiveRecord::OnUpdateDestroy.create!( :name => 'Bart' )
    #   # }.to_not change( Audited.audit_class, :count )
    # end
  end

  describe "on update" do
    let( :user ) { create_user}

    it "should call audit_update" do
      user.stub(:audit_update)

      user.save

      expect(user).to have_received(:audit_update)
    end

    it "should call handle_audit" do
      user.stub(:handle_audit)

      user.update(name:'Tom')

      audited_attributes={"name"=> ["Brandon", "Tom"]}
      expect(user).to have_received(:handle_audit).with(action: 'update', audited_changes: audited_attributes)
    end

  end
end
