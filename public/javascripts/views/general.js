jQuery(document).ready(function(){
	exibeFlashMessage();
	aplicarLoadLogin();
});
  
function exibeFlashMessage(){
	$(".flash_msg").slideDown("slow").delay(4000).slideUp("slow", function(){
		$(this).remove();
	});
}

function bloquearBotao(elemento, texto) {
	elemento.disable();
	elemento.attr("value", texto);
}

function aplicarLoadLogin(){
	$("a#link_login").click(function(){
		$(this).hide();
		$("#executando_login").show();
	})
}