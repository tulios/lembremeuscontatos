jQuery(document).ready(function(){adicionarAutoCompleteDeContato();aplicarBloquearBotaoESubmeterForm()});function aplicarBloquearBotaoESubmeterForm(){$("#submit_grupo").click(function(a){a.preventDefault();bloquearBotao($(this),"Salvando...");$("form").submit()})}function adicionarAutoCompleteDeContato(){$("#contato_search_field").autocomplete({minLength:2,source:function(b,a){consultarNomes(b,a)},select:function(a,b){adicionarContato(b.item.id,b.item.value);return false}})}function consultarNomes(b,a){$.ajax({url:"/users/contatos/pelo_nome?nome="+$("#contato_search_field").attr("value"),dataType:"json",success:function(d,c){a(mapearJSON(d))}})}function mapearJSON(a){return $.map(a,function(b){return{label:b.contato.nome,value:b.contato.nome,id:b.contato.id}})}function adicionarContato(g,b){var a=$("#nomes_container");var f=$("#contato_search_field");var e="contato_"+g;if($("#"+e,a).length==0){var c="<a href='#' id='link_"+e+"'>remover</a>";var d=$("<div id='"+e+"'><input type='hidden' value='"+g+"' name='contatos[]'/><span>"+b+"</span><span class='opcoes'>"+c+"</span></div>");d.addClass("item_contato_box");d.addClass("round");d.appendTo(a);aplicarRemocao(e)}f.attr("value","")}function aplicarRemocao(a){var b=$("#"+a);$("#link_"+a).click(function(c){c.preventDefault();b.remove()})};