Extension { #name : #PRCommand }

{ #category : #'*pier-seaside-accessing' }
PRCommand >> cssClass [
	"Answer a CSS class that should be used in the body-tag when dis command is rendered."

	^ self class fullName asLowercase allButFirst: 2
]

{ #category : #'*pier-seaside-accessing' }
PRCommand >> rendererInstance [
	"Answer a renderer, that is the visitor that is used to display the page."

	^ PRViewRenderer new
]

{ #category : #'*pier-seaside-accessing' }
PRCommand >> robots [
	^ 'noindex,follow'
]
