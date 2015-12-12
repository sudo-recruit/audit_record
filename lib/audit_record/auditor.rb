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
        class_attribute :auditable_name,   instance_writer: false


        if options[:only]
          except = column_names - Array(options[:only]).flatten.map(&:to_s)
        else
          except = default_ignored_attributes + AuditRecord.ignored_attributes
          except |= Array(options[:except]).collect(&:to_s) if options[:except]
        end

        self.non_audited_columns = except
        self.auditable_name = options[:auditable_name]


        after_create :audit_create
        after_update :audit_update
        after_destroy :audit_destroy

        after_commit :handle_audit

      end

      def default_ignored_attributes
        [primary_key, inheritance_column]
      end

    end


    module LocalInstanceMethods
      attr_accessor :action,:audited_changes_attrs

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

      def handle_audit()
        if audited_changes_attrs.present?
          a=AuditRecord::Audit.new
          attrs={action:action,audited_changes:audited_changes_attrs}
          attrs[:auditable_type]=self.class.to_s
          attrs[:auditable_id]=self.id

          if auditable_name.present?&&self.respond_to?(*auditable_name)
            attrs[:auditable_name]=self.send(*auditable_name)
          end

          a.create(attrs)
        end
      end

      def audit_create
        self.action='create'
        self.audited_changes_attrs=audited_attributes
      end

      def audit_update
        if (changes = audited_changes).empty?
          self.action=nil
          self.audited_changes_attrs=nil
        else
          self.action='update'
          self.audited_changes_attrs=changes
        end
      end

      def audit_destroy
        self.action='destroy'
        self.audited_changes_attrs='destroy'
      end
    end
  end
end

ActiveRecord::Base.send :include, AuditRecord::Auditor
