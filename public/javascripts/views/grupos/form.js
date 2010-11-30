jQuery(document).ready(function(){
	 
	adicionarAutoCompleteDeContato();
	aplicarBloquearBotaoESubmeterForm();
	
  $("#grupo_periodicidade").numeric();
	
});

function aplicarBloquearBotaoESubmeterForm(){
	$("#submit_grupo").click(function(e){
		e.preventDefault();
		bloquearBotao($(this), 'Salvando...');
		$("form").submit();
	});
}

function adicionarAutoCompleteDeContato(){  
	$("#contato_search_field").autocomplete({
		minLength: 2,
	  source: function(request, response) {
			consultarNomes(request, response);
		},
		select: function(event, obj){
			adicionarContato(obj.item.id, obj.item.value);
			return false;
		}
	});
}

function consultarNomes(request, response){
  $.ajax({
		url: '/users/contatos/pelo_nome?nome=' + $("#contato_search_field").attr('value'),
		dataType: "json",
		success: function (data, status) {
			response(mapearJSON(data))
		}
	});
}

function mapearJSON(data) {
	return $.map(data, function(json) {
	  return {
		  label: json.contato.nome + ' &raquo; ' + json.contato.email,
			value: json.contato.nome + ' &raquo; ' + json.contato.email,
			id: json.contato.id
		}
	})
}

function adicionarContato(id, nome){
	var container = $("#nomes_container");
	var field = $("#contato_search_field");
	var idDiv = "contato_" + id;

	// Se ainda não tiver sido associado, adiciona
	if ($("#" + idDiv, container).length == 0) {
		var remover = "<a href='#' id='link_" + idDiv + "'>remover</a>";
		var item = $(
			"<div id='" + idDiv + "'>" +
			"<input type='hidden' value='" + id + "' name='contatos[]'/>" + 
			"<span>" + nome + "</span>" + 
			"<span class='opcoes'>" + remover + "</span>" +
			"</div>"
		);
		item.addClass("item_contato_box");
		item.addClass("round");
		item.appendTo(container);                   
  	aplicarRemocao(idDiv);
	}
	// Limpando o campo
	field.attr('value', '');
}                                       

function aplicarRemocao(idDiv) {
	var div = $("#"+idDiv);
	$("#link_"+idDiv).click(function(e){
		e.preventDefault();
		div.remove();
	});
}



















