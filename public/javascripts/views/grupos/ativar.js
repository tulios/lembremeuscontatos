jQuery(document).ready(function(){

  $("#grupo_inicio").mask("99/99/9999");
  $("#grupo_qtd_envios").numeric();
	 
	$("a#ativar").fancybox({
		autoScale: false,
		overlayOpacity: 0.7,
		autoDimensions: true, 
		onComplete: function(){
		}
	});
	
	aplicarBloquearBotaoESubmeterForm();
	
});

function aplicarBloquearBotaoESubmeterForm(){
	$("#submit_grupo").click(function(e){
		e.preventDefault();
		bloquearBotao($(this), 'Ativando...');
		$("#ativar_form").submit();
	});
}