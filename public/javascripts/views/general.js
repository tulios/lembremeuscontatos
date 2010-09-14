jQuery(document).ready(function(){
	exibeFlashMessage();
});
  
function exibeFlashMessage(){
	$(".flash_msg").slideDown("slow").delay(5000).slideUp("slow", function(){
		$(this).remove();
	});
}

function bloquearBotao(elemento, texto) {
	elemento.disable();
	elemento.attr("value", texto);
}