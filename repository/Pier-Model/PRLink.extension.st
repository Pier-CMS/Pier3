Extension { #name : #PRLink }

{ #category : #'*pier-model' }
PRLink >> owner [
	^ self propertyAt: 'owner' ifAbsent: [ nil ]
]

{ #category : #'*pier-model' }
PRLink >> owner: anObject [
	self propertyAt: 'owner' put: anObject.
	super owner: anObject.
	self update
]

{ #category : #'*pier-model' }
PRLink >> update [
	"Update the dynamic information of links, such as references and links."
]
