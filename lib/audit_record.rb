
require 'audit_record/auditor'
require 'audit_record/audit'


module AuditRecord
  class << self
    attr_accessor :ignored_attributes,:handle_audit,:current_user_method, :audit_class
    # , :current_user_method, :audit_class
    def store
      Thread.current[:audited_store] ||= {}
    end
  end

  @ignored_attributes = %w(lock_version created_at updated_at created_on updated_on password)
  @current_user_method = :current_user
end

AuditRecord.audit_class = AuditRecord::Audit
require 'audit_record/sweeper'
