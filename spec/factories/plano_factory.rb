Factory.define :plano do |f|
  f.user {|user| user.association(:user) }
  f.nome 'Plano X -- Somente teste'
  f.num_contatos = 10
  f.num_grupos = 2
  f.periodicidade_min = 10
end

