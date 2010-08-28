jQuery(document).ready(function(){
});

function bloquearBotao(elemento, texto) {
	elemento.disable();
	elemento.attr("value", texto);
}