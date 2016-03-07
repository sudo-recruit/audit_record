#RecordAuditor
> audit ActiveRecord change

heavily inspired by [audited](https://github.com/collectiveidea/audited)

##How To Start
###1. Add below to `config/initializer/record_auditor.rb`

```rb
RecordAuditor.handle_audit=Proc.new{|options|puts options} #change to whatever you want to audit active record
RecordAuditor.current_user_method=:current_rollbar_user #your custom current_user method
```

###2. add `audit` to the model you want to audit
```rb
class User < ::ActiveRecord::Base
   audit
   ...
end
```

MIT