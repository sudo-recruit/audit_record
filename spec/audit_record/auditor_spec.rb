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

    it "should call handle_audit" do
      user.stub(:handle_audit)

      user.save

      expect(user).to have_received(:handle_audit)
    end

    it "should create AuditRecord::Audit instance with correct params" do
      audit = spy('audit')
      AuditRecord::Audit.stub(:new).and_return(audit)

      user.save

      audited_attributes={"name"=> 'darth', "username"=> 'darth',"activated"=>nil, "suspended_at"=>nil, "logins"=>0}
      auditable_type='Models::ActiveRecord::User'
      expect(audit).to have_received(:create).with(action: 'create',auditable_type:auditable_type,auditable_name:"darth",
                                                   audited_changes:audited_attributes,auditable_id:kind_of(Numeric))
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

    context 'when update attributes != empty' do
      it "should call audit_update" do
        user.stub(:audit_update)

        user.update(name:'Tom')

        expect(user).to have_received(:audit_update)
      end

      it "should call handle_audit" do
        user.stub(:handle_audit)

        user.update(name:'Tom')

        expect(user).to have_received(:handle_audit)
      end

      it "should create AuditRecord::Audit instance with correct params" do
        user2=create_user
        audit = spy('audit')
        AuditRecord::Audit.stub(:new).and_return(audit)

        user2.update(name:'Tom')

        audited_attributes={"name"=> ["Brandon", "Tom"]}
        auditable_type='Models::ActiveRecord::User'
        expect(audit).to have_received(:create).with(action: 'update',auditable_type:auditable_type,auditable_name:"Tom",
                                                     audited_changes:audited_attributes,auditable_id:kind_of(Numeric))
      end

    end

    context 'when update attributes == empty' do
      it "should call audit_update" do
        user.stub(:audit_update)

        user.update(name:'Brandon')

        expect(user).to have_received(:audit_update)
      end

      it "should call handle_audit" do
        user.stub(:handle_audit)

        user.update(name:'Brandon')

        expect(user).to have_received(:handle_audit)
      end

      it "should not call create in AuditRecord::Audit instance" do
        user2=create_user
        audit = spy('audit')
        AuditRecord::Audit.stub(:new).and_return(audit)

        user2.update(name:'Brandon')

        audited_attributes={"name"=> ["Brandon", "Tom"]}
        auditable_type='Models::ActiveRecord::User'
        expect(audit).to_not have_received(:create)
      end

    end
  end

  describe "on destroy" do
    let( :user ) { create_user}

    it "should call audit_destroy" do
      user.stub(:audit_destroy)

      user.destroy

      expect(user).to have_received(:audit_destroy)
    end

    it "should call handle_audit" do
      user2=create_user
      user2.stub(:handle_audit)

      user2.destroy

      expect(user2).to have_received(:handle_audit)
    end

    it "should create AuditRecord::Audit instance with correct params" do
      user2=create_user
      audit = spy('audit')
      AuditRecord::Audit.stub(:new).and_return(audit)

      user2.destroy

      auditable_type='Models::ActiveRecord::User'
      expect(audit).to have_received(:create).with(action: 'destroy',auditable_type:auditable_type,auditable_name:"Brandon",
                                                   audited_changes:'destroy',auditable_id:kind_of(Numeric))
    end
  end

end
