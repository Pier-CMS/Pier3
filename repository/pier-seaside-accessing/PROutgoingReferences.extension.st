Extension { #name : #PROutgoingReferences }

{ #category : #'*pier-seaside-accessing' }
PROutgoingReferences >> embeddedComponents [
	^ self select: [ :each | each isInternal and: [ each isEmbedded and: [ each isBroken not and: [ each target isComponent ] ] ] ]
]
