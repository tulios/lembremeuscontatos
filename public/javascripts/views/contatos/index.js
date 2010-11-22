jQuery(document).ready(function(){
	 
	$("a.novo_contato").fancybox({
		type: 'ajax',
		titleShow: false,
		overlayOpacity: 0.7,
		autoDimensions: true, 
		onComplete: function(){
			$('input:not(:hidden):first').focus();
		}
	});
	
});