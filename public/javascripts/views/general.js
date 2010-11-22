jQuery(document).ready(function(){
	exibeFlashMessage();
	aplicarLoadLogin();
	
	$('input:not(:hidden):first').focus();
});
  
function exibeFlashMessage(){
	$(".flash_msg").slideDown("slow").delay(3000).slideUp("slow", function(){
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