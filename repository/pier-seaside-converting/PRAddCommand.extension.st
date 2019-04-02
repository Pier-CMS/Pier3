Extension { #name : #PRAddCommand }

{ #category : #'*pier-seaside-converting' }
PRAddCommand >> saveButton [
	^ super saveButton value: self class label
]
