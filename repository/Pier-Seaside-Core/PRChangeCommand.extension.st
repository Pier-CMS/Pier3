Extension { #name : #PRChangeCommand }

{ #category : #'*pier-seaside' }
PRChangeCommand >> applyButton [
	^ #apply -> 'Apply'
]

{ #category : #'*pier-seaside' }
PRChangeCommand >> buttonSpecification [
	^ Array with: self saveButton with: self applyButton with: self cancelButton
]

{ #category : #'*pier-seaside' }
PRChangeCommand >> doAnswer [
	super doAnswer.
	self structure isComponent
		ifTrue: [ self structure flush ]
]
