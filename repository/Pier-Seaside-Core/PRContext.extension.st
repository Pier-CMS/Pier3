Extension { #name : #PRContext }

{ #category : #'*pier-seaside-private' }
PRContext >> activationCallback [
	^ WAActionCallback on: [
			PRCurrentContext value: self.
			(self command isView and: [ self command viewComponent isFullResponse ])
				ifTrue: [ self command viewComponent handle: self requestContext ] ]
]

{ #category : #'*pier-seaside-private' }
PRContext >> buildComponent: aStructure for: aLink [
	^ (aStructure componentFor: aLink)
		onChangeContext: self;
		yourself
]

{ #category : #'*pier-seaside-private' }
PRContext >> componentDictionary [
	^ self propertyAt: #components ifAbsentPut: [ IdentityDictionary new ]
]

{ #category : #'*pier-seaside-caching' }
PRContext >> componentFor: aLink [
	"Return the cached component of aLink, if none is existing yet create a new one."

	^ self componentDictionary at: aLink ifAbsentPut: [ self buildComponent: aLink target for: aLink ]
]

{ #category : #'*pier-seaside-caching' }
PRContext >> flushComponent: aStructure [
	"Flush all the components that are instantiated from aStructure."
	
	self componentDictionary keys do: [ :each |
		each target = aStructure 
			ifTrue: [ self componentDictionary removeKey: each ifAbsent: [ ] ] ]
]

{ #category : #'*pier-seaside-private' }
PRContext >> sanitizeSeasideCache [
	<sanitize>
	
	self properties
		removeKey: #components ifAbsent: [ ];
		removeKey: #session ifAbsent: [ ];
		removeKey: #application ifAbsent: [ ]
]

{ #category : #'*pier-seaside-navigation' }
PRContext >> structure: aStructure view: aViewComponentClass [
	"Create a copy of the current context with the current structure replaced by ==aStructure== and the current view by ==aViewComponent==."

	^ self structure: aStructure command: (aStructure viewCommandClass new
		viewComponentClass: aViewComponentClass;
		yourself)
]

{ #category : #'*pier-seaside-urls' }
PRContext >> url [
	"Answer a REST URL to get into the receiving context."
	
	^ self application url
		takeServerParametersFromRequest: self requestContext request;
		adaptToContext: self;
		yourself
]

{ #category : #'*pier-seaside-urls' }
PRContext >> urlOn: aRenderer [
	"Answer a Seaside URL to get into the receiving context."

	| url |
	^ aRenderer callbacks isNil
		ifTrue: [ self url ]
		ifFalse: [ 
			url := aRenderer context actionUrl copy.
			url
				purgeOtherFields;
				adaptToContext: self.
			(self command isRestful
				and: [ 
					(self application trackingStrategy isKindOf: WACookieSessionTrackingStrategy)
						and: [ (self application trackingStrategy cookieFromContext: self requestContext ifAbsent: [ nil ]) notNil ] ])
				ifTrue: [ url purgeSeasideFields ]
				ifFalse: [ 
					url queryFields
						at: '_n' put: nil;
						at: (aRenderer callbacks store: self activationCallback) put: nil ].
			url ]
]

{ #category : #'*pier-seaside-navigation' }
PRContext >> view: aViewComponentClass [
	"Create a copy of the current context ==aViewComponent==."

	^ self structure: self structure view: aViewComponentClass
]
