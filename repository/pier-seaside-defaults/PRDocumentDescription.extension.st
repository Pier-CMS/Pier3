Extension { #name : #PRDocumentDescription }

{ #category : #'*pier-seaside-defaults' }
PRDocumentDescription class >> defaultComponentClasses [
	^ Array with: PRDocumentComponent
]

{ #category : #'*pier-seaside-defaults' }
PRDocumentDescription class >> defaultCssClasses [
	^ super defaultCssClasses add: 'wiki'; yourself
]
