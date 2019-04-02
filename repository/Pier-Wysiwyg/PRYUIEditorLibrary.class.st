Class {
	#name : #PRYUIEditorLibrary,
	#superclass : #WAFileLibrary,
	#category : #'Pier-Wysiwyg'
}

{ #category : #processing }
PRYUIEditorLibrary >> updateRoot: anHtmlRoot [
	"see http://developer.yahoo.com/yui/articles/hosting/?editor#configure"
	super updateRoot: anHtmlRoot.
	
	anHtmlRoot stylesheet url: 'http://yui.yahooapis.com/combo?2.9.0/build/assets/skins/sam/skin.css'.
	anHtmlRoot javascript
		url: 'http://yui.yahooapis.com/combo?2.9.0/build/yahoo-dom-event/yahoo-dom-event.js&2.9.0/build/element/element-min.js&2.9.0/build/container/container_core-min.js&2.9.0/build/menu/menu-min.js&2.9.0/build/button/button-min.js&2.9.0/build/editor/editor-min.js'
]
