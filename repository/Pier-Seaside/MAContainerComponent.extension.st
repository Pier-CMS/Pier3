Extension { #name : #MAContainerComponent }

{ #category : #'*Pier-Seaside-actions' }
MAContainerComponent >> apply [
	"This is an ugly hack that will only work in the context of Pier. It assumes that the underlying model is a command and that it can be told to redisplay itself."
	
	self validate ifFalse: [ ^ self ].
	self commit.
	self model answer isNil
		ifTrue: [ self model answer: self model context copy ].
	self answer: self model
]
