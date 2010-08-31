Factory.define :contato do |f|
  f.user {|user| user.association(:user) }
  f.nome 'Hal 9000'
  f.sequence(:email) {|n| "contato#{n}@space.com" }
end
