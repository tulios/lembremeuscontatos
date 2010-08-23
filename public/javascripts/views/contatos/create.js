jQuery(document).ready(function(){
	 
	var contatos_path = $("#contatos_ajax").attr("value");
	
	$.ajax({
	  url: contatos_path,
		type: 'GET',
	  success: function(data, request) {
			$.fancybox.close();
			$(".contatos").html(data);
	  }
	});
	
});