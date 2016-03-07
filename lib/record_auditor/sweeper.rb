require "rails/observers/activerecord/active_record"
require "rails/observers/action_controller/caching"

module RecordAuditor
  class Sweeper < ActionController::Caching::Sweeper
    observe RecordAuditor.audit_class

    attr_accessor :controller

    def around(controller)
      begin
        self.controller = controller
        yield
      ensure
        self.controller = nil
      end
    end

    def before_create(audit)
      audit.user ||= current_user
      # audit.remote_address = controller.try(:request).try(:remote_ip)
    end

    def current_user
      controller.send(RecordAuditor.current_user_method) if controller.respond_to?(RecordAuditor.current_user_method, true)
    end

    def add_observer!(klass)
      # super
      define_callback(klass)
    end

    def define_callback(klass)
      observer = self
      callback_meth = :_notify_audited_sweeper
      klass.send(:define_method, callback_meth) do
        observer.update(:before_create, self)
      end
      klass.send(:before_create, callback_meth)
    end

    def controller
      ::RecordAuditor.store[:current_controller]
    end

    def controller=(value)
      ::RecordAuditor.store[:current_controller] = value
    end
  end
end

if defined?(ActionController) && defined?(ActionController::Base)
  ActionController::Base.class_eval do
    around_filter RecordAuditor::Sweeper.instance
  end
end