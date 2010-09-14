jQuery(document).ready(function(){
	 
	$("a#desativar").fancybox({
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
		bloquearBotao($(this), 'Desativando...');
		$("#desativar_form").submit();
	});
}