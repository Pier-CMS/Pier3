Extension { #name : #PRChangeCommand }

{ #category : #'*Pier-Seaside' }
PRChangeCommand >> applyButton [
	^ #apply -> 'Apply'
]

{ #category : #'*Pier-Seaside' }
PRChangeCommand >> buttonSpecification [
	^ Array with: self saveButton with: self applyButton with: self cancelButton
]

{ #category : #'*Pier-Seaside' }
PRChangeCommand >> doAnswer [
	super doAnswer.
	self structure isComponent
		ifTrue: [ self structure flush ]
]
