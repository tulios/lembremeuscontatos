jQuery(document).ready(function(){
	
	aplicarAjaxSubmit();
	
});

function aplicarAjaxSubmit(){
	$("#submit_contato").click(function(e){
		e.preventDefault();
		                   
		var botao = $(this);
		
		$.ajax({
		  url: $("#new_contato").attr("action"),
			type: 'POST',
			data: $("#new_contato").serialize(),
			beforeSend: function(request){
				botao.attr('disabled', true);
				botao.attr('value', 'Enviando...');
			},
		  success: function(data, request) {
				tratarSucesso(data, request);
		  }
		});
		 
	});
}

function tratarSucesso(data, request) {
	$(".contato_form").html(data);
	$(".contato_form").css('height', '300px');
}


































