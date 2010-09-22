Factory.define :plano do |f|
  f.sequence(:nome) {|n| "Plano mestre #{n}"}
  f.num_contatos 10
  f.num_grupos 2
  f.periodicidade_min 6
end

