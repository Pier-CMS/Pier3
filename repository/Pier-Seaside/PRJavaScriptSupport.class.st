Class {
	#name : #PRJavaScriptSupport,
	#superclass : #WAFileLibrary,
	#category : #'Pier-Seaside-Libraries'
}

{ #category : #files }
PRJavaScriptSupport >> pierJs [
	^ '(function(){
	var load = function(event) {
		if (document.forms.length > 0) {
			if (document.forms[0].parentNode.className != "leavecomment" && document.forms[0].parentNode.className !="addnote") {
				var elements = document.forms[0].elements;
				for (var i = 0; i < elements.length; i++) {
					if (elements[i].parentNode.tagName == "TD") {
						elements[i].focus();
						break;
					}
				}
			}
		}
	};
	if (window.addEventListener)
		window.addEventListener("load", load, false)
	else
		window.attachEvent("onload", load);
})();'
]

{ #category : #accessing }
PRJavaScriptSupport >> selectorsToInclude [
	^ #(pierJs)
]
