module RecordAuditor
  class Audit
    # include ActiveModel::Observing
    extend ActiveModel::Callbacks
    include ActiveModel::Conversion
    # extend ActiveModel::Translation
    include ActiveModel::Model
    define_model_callbacks :create

    attr_accessor :user,:auditable

    def create(attrs={})
      run_callbacks(:create) do
        # handle something here
        if RecordAuditor.handle_audit.present?
          RecordAuditor.handle_audit.call(attrs.merge(user:user))
        end
      end
    end

  end
end
