Extension { #name : #WAAnchorTag }

{ #category : #'*Pier-Seaside-linking' }
WAAnchorTag >> goto: aContext [
	"Initialize the receiver to properly activate aContext when being clicked. This includes a callback and a human-readable and bookmarkable url."

	aContext isValid
		ifFalse: [ self class: 'protected' ].
	(self attributes includesKey: 'title') 
		ifFalse: [ self title: aContext command label ].
	(aContext command isView not and: [ aContext command class accessKey notNil ])
		ifTrue: [ self attributes at: 'title' append: '(' , aContext command class accessKey greaseString , ')' ].
	self class: aContext structure cssClass.
	self url: (aContext urlOn: canvas)
]
