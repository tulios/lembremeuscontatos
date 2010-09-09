Factory.define :grupo do |f|
  f.user {|user| user.association(:user) }
  f.sequence(:nome) {|n| "Nome #{n}" }
  f.mensagem "Uma mensagem de exemplo!"
  f.periodicidade 6
end
