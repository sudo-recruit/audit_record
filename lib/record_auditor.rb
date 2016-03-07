require 'record_auditor/auditor'
require 'record_auditor/audit'


module RecordAuditor
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

RecordAuditor.audit_class = RecordAuditor::Audit
require 'record_auditor/sweeper'
