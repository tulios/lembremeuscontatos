jQuery(document).ready(function(){var a=$("#contatos_ajax").attr("value");$.ajax({url:a,type:"GET",success:function(c,b){$.fancybox.close();$(".contatos").html(c)}})});