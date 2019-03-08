Extension { #name : #PRExternalLink }

{ #category : #'*pier-model' }
PRExternalLink >> embedded [
	^ false
]

{ #category : #'*pier-model' }
PRExternalLink >> embedded: aBoolean [
	aBoolean
		ifTrue: [ Transcript show: 'PRExternalLink>>embedded: called with true, should not happen.' ]
]
