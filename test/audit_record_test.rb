require 'test_helper'

class AuditRecordTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, AuditRecord
  end
end
