jQuery(document).ready(function(){
	 
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