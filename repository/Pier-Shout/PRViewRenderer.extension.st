Extension { #name : #PRViewRenderer }

{ #category : #'*pier-shout' }
PRViewRenderer >> visitHighlightedCode: anObject [
	html preformatted class: 'shout'; with: anObject
]
