Factory.define :grupo do |f|
  f.user {|user| user.association(:user) }
  f.sequence(:nome) {|n| "nome_grupo#{n}" }
  f.mensagem 'insira aqui uma mensagem'
  f.periodicidade rand(5) + 5
  f.inicio DateTime.now + (rand(5) + 1).day
end
