module AuditRecord
  module Auditor
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def get_id
        1
      end

      def audit(options = {})
        include AuditRecord::Auditor::LocalInstanceMethods
        class_attribute :non_audited_columns,   instance_writer: false

        if options[:only]
          except = column_names - Array(options[:only]).flatten.map(&:to_s)
        else
          except = default_ignored_attributes + AuditRecord.ignored_attributes
          except |= Array(options[:except]).collect(&:to_s) if options[:except]
        end

        self.non_audited_columns = except

        after_create :audit_create
        after_update :audit_update

      end

      def default_ignored_attributes
        [primary_key, inheritance_column]
      end

    end


    module LocalInstanceMethods

      def audited_attributes
        attributes.except(*non_audited_columns)
      end

      private

      def audited_changes
        changed_attributes.except(*non_audited_columns).inject({}) do |changes, (attr, old_value)|
          changes[attr] = [old_value, self[attr]]
          changes
        end
      end

      def handle_audit(attrs)
        a=AuditRecord::Audit.new
        attrs[:auditable_type]=self.class.to_s
        attrs[:auditable_id]=self.id
        a.create(attrs)
      end

      def audit_create
        handle_audit(action: 'create', audited_changes: audited_attributes)
      end

      def audit_update
        unless (changes = audited_changes).empty?
          handle_audit(action: 'update', audited_changes: changes)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, AuditRecord::Auditor
