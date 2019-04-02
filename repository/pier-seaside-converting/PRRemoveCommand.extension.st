Extension { #name : #PRRemoveCommand }

{ #category : #'*pier-seaside-converting' }
PRRemoveCommand >> saveButton [
	^ super saveButton value: self class label
]
