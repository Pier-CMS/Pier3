Extension { #name : #PRMailLink }

{ #category : #'*Pier-Model' }
PRMailLink class >> isValidReference: aString [
	| index |
	index := aString indexOf: $@ ifAbsent: [ ^ false ].
	index := aString indexOf: $. startingAt: index ifAbsent: [ ^ false ].
	^ aString allSatisfy: [ :each | each isAlphaNumeric or: [ '@-._' includes: each ] ]
]
