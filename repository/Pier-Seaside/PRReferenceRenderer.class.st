"
I render links as titles, changing something like */path/name-space-name* to display as:
 Name Space Name
"
Class {
	#name : #PRReferenceRenderer,
	#superclass : #PRLinkRenderer,
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #private }
PRReferenceRenderer >> configureCommandIn: aContext link: aLink [
	aContext command magritteDescription do: [ :description |
		aLink
			parameterAt: description parameterName
			ifPresent: [ :value | aContext command write: (description fromString: value) using: description ] ]
]

{ #category : #private }
PRReferenceRenderer >> configureViewIn: aContext link: aLink [
	aContext command isView
		ifFalse: [ ^ self ].
	aContext command viewComponent magritteDescription do: [ :description |
		aLink
			parameterAt: description parameterName
			ifPresent: [ :value | aContext command viewComponent write: (description fromString: value) using: description ] ]
]

{ #category : #private }
PRReferenceRenderer >> contextForCommandIn: aContext link: aLink [
	aLink parameterAt: 'command' ifPresent: [ :name |
		PRCommand withAllConcreteClassesDo: [ :class |
			(class name greaseString = name or: [ class label = name ]) 
				ifTrue: [ ^ aContext command: class new ] ] ].
	^ aContext
]

{ #category : #querying }
PRReferenceRenderer >> contextForLink: aLink [
	| context |
	context := self context structure: aLink target.
	context := self contextForCommandIn: context link: aLink.
	self configureCommandIn: context link: aLink.
	context := self contextForViewIn: context link: aLink.
	self configureViewIn: context link: aLink.
	^ context
]

{ #category : #private }
PRReferenceRenderer >> contextForViewIn: aContext link: aLink [
	aLink parameterAt: 'view' ifPresent: [ :name |
		PRViewComponent withAllConcreteClassesDo: [ :class |
			(class name greaseString = name or: [ class label = name ]) 
				ifTrue: [ ^ aContext view: class ] ] ].
	^ aContext
]

{ #category : #'visiting-document' }
PRReferenceRenderer >> visitExternalLink: aLink [
	(self anchorFor: aLink)
		class: 'external'; 
		url: aLink url;
		with: [ self visitLink: aLink ]
]

{ #category : #'visiting-document' }
PRReferenceRenderer >> visitInternalLink: aLink [
	| anchor |
	anchor := self anchorFor: aLink.
	anchor class: 'internal'; goto: (self contextForLink: aLink).
	aLink anchor isNil ifFalse: [ 
		anchor url fragment: (aLink anchor
			select: [ :each | each isAlphaNumeric ]) ].
	anchor with: [ self visitLink: aLink ]
]

{ #category : #'visiting-document' }
PRReferenceRenderer >> visitValueLink: aLink [
	"Value links are always embedded, there is no point in not embedding them. Values can be either a document (the document is visited) or any other Smalltalk object (the value is renderered). If the value is nil, the alias of the link is displayed."

	| value |
	value := aLink valueIn: self context.
	value isNil
		ifTrue: [ ^ self visitLink: aLink ].
	(value isCollection and: [ value isString not ])
		ifTrue: [ ^ parent visitAll: value ].
	(value isKindOf: PRDocumentItem)
		ifTrue: [ ^ parent visit: value ].
	html render: value
]
