Extension { #name : #Collection }

{ #category : #'*pier-model' }
Collection >> accept: aVisitor [
	aVisitor visitAll: self
]
