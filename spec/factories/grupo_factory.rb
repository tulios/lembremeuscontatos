Factory.define :grupo do |f|
  f.user {|user| user.association(:user) }
  f.sequence(:nome) {|n| "Nome Grupo #{n}" }
  f.mensagem 'Uma mensagem de exemplo!'
  f.periodicidade rand(6) + 5
  f.inicio DateTime.now + (rand(6) + 1).day
end
