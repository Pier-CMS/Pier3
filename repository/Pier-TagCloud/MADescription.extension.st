Extension { #name : #MADescription }

{ #category : #'*pier-tagcloud' }
MADescription >> beTagCloud [
	self propertyAt: #tagCloud put: true
]

{ #category : #'*pier-tagcloud' }
MADescription >> isTagCloud [
	^ self propertyAt: #tagCloud ifAbsent: [ false ]
]
