Factory.define :grupo_contato do |f|
  f.grupo {|grupo| grupo.association(:grupo) }
  f.contato {|contato| contato.association(:contato) }
end
