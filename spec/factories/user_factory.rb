Factory.define :user do |f|
  f.sequence(:login) {|n| "twit_login#{n}" }
  f.sequence(:twitter_id) {|n| "#{n}" }
  f.plano {|plano| plano.association(:plano) }
end

