Extension { #name : #PRTable }

{ #category : #'*Pier-SW2-Sw1Features' }
PRTable >> accept: aVisitor [
	aVisitor visitPierTable: self
]
