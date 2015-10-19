require "spec_helper"
require 'pry'


class AuditsController < ActionController::Base
  def audit
    @user = Models::ActiveRecord::User.create
    render nothing: true
  end

  def update_user
    current_user.update_attributes(password: 'foo')
    render nothing: true
  end

  private

  attr_accessor :current_user
  attr_accessor :custom_user
end

describe AuditsController do

  include RSpec::Rails::ControllerExampleGroup
  render_views

  before(:each) do
    AuditRecord.current_user_method = :current_user
  end

  let( :user ) { create_user }

  it "should call handle_audit when auditable change" do
    controller.send(:current_user=, user)
    AuditRecord.stub(:handle_audit)

    post :audit

    expect(AuditRecord).to have_received(:handle_audit)
  end
end
