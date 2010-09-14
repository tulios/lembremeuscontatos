# =============================================================================
# Cria alguns usuários para teste do sistema
# =============================================================================
unless test = Plano.find_by_nome("Plano Gratuito 1")
  test = Plano.create(
    :nome => "Plano Gratuito",
    :num_contatos => 10,
    :num_grupos => 2,
    :periodicidade_min => 10
  )
end

