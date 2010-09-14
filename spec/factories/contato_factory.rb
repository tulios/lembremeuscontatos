Factory.define :contato do |f|
  f.user {|user| user.association(:user) }
  f.sequence(:nome) {|n| "C#{n}P0" } 
  f.sequence(:email) {|n| "contato#{n}@cxp0-group.com" }
end
