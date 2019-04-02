Extension { #name : #PRChangeCommand }

{ #category : #'*pier-editorenh' }
PRChangeCommand >> updateRoot: aHtmlRoot [
	| handler |
	super updateRoot: aHtmlRoot.
	PREditorScripts default updateRoot: aHtmlRoot.
	handler := PREditorHandler on: self context copy sanitize.
	aHtmlRoot javascript
		add: 'EditorEnh.linkOptionUrl=' , (WACurrentRequestContext value registry
		register: handler;
		urlFor: handler) asJavascript 
]
