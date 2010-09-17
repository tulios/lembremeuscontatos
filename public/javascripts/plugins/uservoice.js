jQuery(document).ready(function(){
	
	var uservoiceOptions = {
	  key: 'lembremeuscontatos',
	  host: 'lembremeuscontatos.uservoice.com', 
	  forum: '76887',
	  lang: 'pt_BR',
	  showTab: false
	};
	function _loadUserVoice() {
	  var s = document.createElement('script');
	  s.src = ("https:" == document.location.protocol ? "https://" : "http://") + "cdn.uservoice.com/javascripts/widgets/tab.js";
	  document.getElementsByTagName('head')[0].appendChild(s);
	}
	_loadSuper = window.onload;
	window.onload = (typeof window.onload != 'function') ? _loadUserVoice : function() { _loadSuper(); _loadUserVoice(); };
	 
	$("#menu_sugestoes").click(function(e){
		e.preventDefault();
		UserVoice.Popin.show(uservoiceOptions);
		return false;
	});
	
});