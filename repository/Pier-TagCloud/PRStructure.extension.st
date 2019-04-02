Extension { #name : #PRStructure }

{ #category : #'*pier-tagcloud-descriptions' }
PRStructure >> descriptionMenuTagCloud: aDescription [
	<magritteDescription: #descriptionMenu>
	^ aDescription beTagCloud
]

{ #category : #'*pier-tagcloud-descriptions' }
PRStructure >> descriptionNameTagCloud: aDescription [
	<magritteDescription: #descriptionName>
	^ aDescription beTagCloud
]

{ #category : #'*pier-tagcloud-descriptions' }
PRStructure >> descriptionTagsTagCloud: aDescription [
	<magritteDescription: #descriptionTags>
	^ aDescription beTagCloud
]

{ #category : #'*pier-tagcloud-descriptions' }
PRStructure >> descriptionTitleTagCloud: aDescription [
	<magritteDescription: #descriptionTitle>
	^ aDescription beTagCloud
]

{ #category : #'*pier-tagcloud' }
PRStructure >> tagsUsing: aCollection [
	"Answer a list of tags using the given aCollection of descriptions."
	
	^ aCollection
		inject: OrderedCollection new
		into: [ :collection :each |
			collection addAll: ((each toString: (self readUsing: each))
				findTokens: ' ').
			collection ]
]
