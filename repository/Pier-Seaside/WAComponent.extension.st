Extension { #name : #WAComponent }

{ #category : #'*Pier-Seaside' }
WAComponent class >> groupLabel [
	^ 'Seaside Component'
]

{ #category : #'*Pier-Seaside-initialization' }
WAComponent >> initializeAttribute: description with: aValue overridWith: anInternalLink [
	"Whenever a component is instantiated it is initialized with the settings from the model, that
	can be overridden with the settings given in the link that embeds the component."

	| preference |
	preference := aValue.
	anInternalLink notNil
		ifTrue: [ description parameterName notNil
				ifTrue: [ anInternalLink
						parameterAt: description parameterName
						ifPresent: [ :value | preference := description fromString: value ] ] ].
	self write: (preference ifNil: [ description default yourself ]) using: description
]

{ #category : #'*Pier-Seaside-initialization' }
WAComponent >> initializeOwner: aStructure link: anInternalLink [
	"Initialize the receiver with the settings from aStructure and overriding parameters of anInternalLink."

	aStructure 
		initializeVisualComponentSettings: self 
		link: anInternalLink
]

{ #category : #'*Pier-Seaside' }
WAComponent class >> owner: aStructure link: anInternalLink [
	^ self new initializeOwner: aStructure link: anInternalLink
]
