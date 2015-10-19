module AuditRecord
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
        binding.pry
        # handle something here
        AuditRecord.handle_audit
      end
    end

  end
end
