(function(a){a().ajaxSend(function(b,d,c){d.setRequestHeader("Accept","text/javascript, text/html, application/xml, text/xml, */*")})})(jQuery);(function(a){a.fn.reset=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};a.fn.enable=function(){return this.each(function(){this.disabled=false})};a.fn.disable=function(){return this.each(function(){this.disabled=true})}})(jQuery);(function(a){a.extend({fieldEvent:function(b,f){var d=b[0]||b,c="change";if(d.type=="radio"||d.type=="checkbox"){c="click"}else{if(f&&d.type=="text"||d.type=="textarea"){c="keyup"}}return c}});a.fn.extend({delayedObserver:function(b,f){var c=a(this);if(typeof window.delayedObserverStack=="undefined"){window.delayedObserverStack=[]}if(typeof window.delayedObserverCallback=="undefined"){window.delayedObserverCallback=function(g){observed=window.delayedObserverStack[g];if(observed.timer){clearTimeout(observed.timer)}observed.timer=setTimeout(function(){observed.timer=null;observed.callback(observed.obj,observed.obj.formVal())},observed.delay*1000);observed.oldVal=observed.obj.formVal()}}window.delayedObserverStack.push({obj:c,timer:null,delay:b,oldVal:c.formVal(),callback:f});var d=window.delayedObserverStack.length-1;if(c[0].tagName=="FORM"){a(":input",c).each(function(){var g=a(this);g.bind(a.fieldEvent(g,b),function(){observed=window.delayedObserverStack[d];if(observed.obj.formVal()==observed.obj.oldVal){return}else{window.delayedObserverCallback(d)}})})}else{c.bind(a.fieldEvent(c,b),function(){observed=window.delayedObserverStack[d];if(observed.obj.formVal()==observed.obj.oldVal){return}else{window.delayedObserverCallback(d)}})}},formVal:function(){var b=this[0];if(b.tagName=="FORM"){return this.serialize()}if(b.type=="checkbox"||self.type=="radio"){return this.filter("input:checked").val()||""}else{return this.val()}}})})(jQuery);(function($){$.fn.extend({visualEffect:function(o){e=o.replace(/\_(.)/g,function(m,l){return l.toUpperCase()});return eval("$(this)."+e+"()")},appear:function(speed,callback){return this.fadeIn(speed,callback)},blindDown:function(speed,callback){return this.show("blind",{direction:"vertical"},speed,callback)},blindUp:function(speed,callback){return this.hide("blind",{direction:"vertical"},speed,callback)},blindRight:function(speed,callback){return this.show("blind",{direction:"horizontal"},speed,callback)},blindLeft:function(speed,callback){this.hide("blind",{direction:"horizontal"},speed,callback);return this},dropOut:function(speed,callback){return this.hide("drop",{direction:"down"},speed,callback)},dropIn:function(speed,callback){return this.show("drop",{direction:"up"},speed,callback)},fade:function(speed,callback){return this.fadeOut(speed,callback)},fadeToggle:function(speed,callback){return this.animate({opacity:"toggle"},speed,callback)},fold:function(speed,callback){return this.hide("fold",{},speed,callback)},foldOut:function(speed,callback){return this.show("fold",{},speed,callback)},grow:function(speed,callback){return this.show("scale",{},speed,callback)},highlight:function(speed,callback){return this.show("highlight",{},speed,callback)},puff:function(speed,callback){return this.hide("puff",{},speed,callback)},pulsate:function(speed,callback){return this.show("pulsate",{},speed,callback)},shake:function(speed,callback){return this.show("shake",{},speed,callback)},shrink:function(speed,callback){return this.hide("scale",{},speed,callback)},squish:function(speed,callback){return this.hide("scale",{origin:["top","left"]},speed,callback)},slideUp:function(speed,callback){return this.hide("slide",{direction:"up"},speed,callback)},slideDown:function(speed,callback){return this.show("slide",{direction:"up"},speed,callback)},switchOff:function(speed,callback){return this.hide("clip",{},speed,callback)},switchOn:function(speed,callback){return this.show("clip",{},speed,callback)}})})(jQuery);jQuery(document).ready(function(){exibeFlashMessage();aplicarLoadLogin()});function exibeFlashMessage(){$(".flash_msg").slideDown("slow").delay(3000).slideUp("slow",function(){$(this).remove()})}function bloquearBotao(b,a){b.disable();b.attr("value",a)}function aplicarLoadLogin(){$("a#link_login").click(function(){$(this).hide();$("#executando_login").show()})};