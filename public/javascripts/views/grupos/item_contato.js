jQuery(document).ready(function(){
	 
	aplicarRemocaoAjax();
	
});

function aplicarRemocaoAjax() {
	$("#nomes_container div").each(function(){
		var div = $(this);
		var link = $("a", div);
		              
		link.click(function(e){
			e.preventDefault();
			apagar(link, div);
		});
		
	});
}

function apagar(link, div){
	var href = link.attr('href');
	$.ajax({
		url: href,
		type: 'DELETE',
		beforeSend: function(request){
			link.attr('href', '#');
			link.html("apagando...");
		},
		success: function (data, status) {
			link.remove();
			$("span.opcoes", div).html("apagado.");
			$("span.nome", div).addClass("removido");
		}
	});
}