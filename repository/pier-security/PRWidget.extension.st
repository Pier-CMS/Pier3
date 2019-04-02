Extension { #name : #PRWidget }

{ #category : #'*pier-security-testing' }
PRWidget >> isSuperuser [
	^ self context user notNil and: [ self context user isSuperuser ]
]
