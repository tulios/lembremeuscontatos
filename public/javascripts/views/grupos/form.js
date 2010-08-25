jQuery(document).ready(function(){
	 
	adicionarAutoCompleteDeContato();
	
	$("#btn_adicionar").click(function(){
		adicionarContato();
	});
	
});

function adicionarContato(){
	var container = $("#nomes_container");
	var field = $("#contato_search_field");
	var value = field.attr("value");
	var attr = value.split("-");
	var idDiv = "contato_" + attr[0];

	// Se ainda não tiver sido associado, adiciona
	if ($("#" + idDiv, container).length == 0) {
		var item = $(
			"<div id='" + idDiv + "'>" +
			"<input type='hidden' value='" + attr[0] + "' name='contatos[]'/>" + 
			"<span>" + attr[1] + "</span>" + 
			"</div>"
		);
		item.addClass("item_contato_box");
		item.addClass("round");
	
		item.appendTo(container);                   
	}
	field.attr('value', '');
}

function adicionarAutoCompleteDeContato(){  
	$("#contato_search_field").autocomplete({
		minLength: 2,
	  source: function(request, response) {
		  $.ajax({
				url: '/users/contatos/pelo_nome?nome=' + $("#contato_search_field").attr('value'),
				dataType: "json",
				success: function (data, status) {
					response(mapearJSON(data))
				}
			})				
		}
	});
}

function mapearJSON(data) {
	return $.map(data, function(json) {
	  return {
		  label: json.contato.nome,
			value: json.contato.id + "-" + json.contato.nome
		}
	})
}