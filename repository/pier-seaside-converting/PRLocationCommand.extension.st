Extension { #name : #PRLocationCommand }

{ #category : #'*pier-seaside-converting' }
PRLocationCommand >> saveButton [
	^ super saveButton value: self class label
]
