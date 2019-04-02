Extension { #name : #PRStructure }

{ #category : #'*pier-seaside-testing' }
PRStructure >> hasContentsWidget [
	^ self embeddedComponents anySatisfy: [ :each | each target componentClass includesBehavior: PRContentsWidget ]
]

{ #category : #'*pier-seaside-testing' }
PRStructure >> isComponent [
	^ false
]

{ #category : #'*pier-seaside-testing' }
PRStructure >> isValidView: aComponentClass in: aContext [
	"Answer true if aComponentClass is a valid command in aContext."

	^ true
]
