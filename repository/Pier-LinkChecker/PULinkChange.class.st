Class {
	#name : #PULinkChange,
	#superclass : #PRObject,
	#instVars : [
		'source',
		'target',
		'status'
	],
	#category : #'Pier-LinkChecker'
}

{ #category : #'instance creation' }
PULinkChange class >> on: aLink [
	^ self basicNew initializeOn: aLink
]

{ #category : #private }
PULinkChange >> httpHead: aString [
	"Answer an array with response code and effective URL, or nil."
        | response | 
                response := ZnClient new 
                url: aString trimBoth; 
                timeout: 5; 
                method: #HEAD; 
                ifFail: [ ^Array with: 404 with: aString ]; 
                executeWithTimeout; 
                response. 
        ^ Array with: response code with: (response headers at: 'Location' ifAbsent: [aString])	. 

]

{ #category : #initialization }
PULinkChange >> initializeOn: aLink [
	self initialize.
	source := aLink.
	target := aLink copy
]

{ #category : #testing }
PULinkChange >> isEnabled [
	^ self source ~= self target
]

{ #category : #testing }
PULinkChange >> isValid [
	^ self status first beginsWith: 'Valid'
]

{ #category : #accessing }
PULinkChange >> owner [
	^ source owner
]

{ #category : #action }
PULinkChange >> refresh [
	status := nil
]

{ #category : #action }
PULinkChange >> repair [
	self target isInternal
		ifTrue: [ self repairInternal ].
	self target isExternal
		ifTrue: [ self repairExternal ]
]

{ #category : #action }
PULinkChange >> repairExternal [
	self status size < 3 ifTrue: [ ^ self ].
	self target reference: self status third second.
	self refresh
]

{ #category : #action }
PULinkChange >> repairInternal [
	| reference matcher |
	reference := self target reference.
	matcher := [ :structure |
		| newTarget |
		newTarget := structure lookupPath: reference.
		newTarget isNil
			ifFalse: [ self refresh. ^ self target target: newTarget; update ] ].
	self owner parents reversed do: matcher.
	self owner enumerator all do: matcher.
	self owner root enumerator everything do: matcher.
	(reference := self target reference copyAfterLast: $/) isEmpty 
		ifTrue: [ ^ self ].
	self owner enumerator everything do: matcher.
	self owner root enumerator everything do: matcher
]

{ #category : #accessing }
PULinkChange >> source [
	^ source
]

{ #category : #accessing }
PULinkChange >> sourceString [
	^ self source reference
]

{ #category : #accessing }
PULinkChange >> status [
	"Answer an array with status message and status string."
	
	^ status ifNil: [ status := self updateStatus ]
]

{ #category : #accessing }
PULinkChange >> target [
	^ target
]

{ #category : #accessing }
PULinkChange >> targetString [
	^ self target reference
]

{ #category : #accessing }
PULinkChange >> targetString: aString [
	self targetString = aString 
		ifTrue: [ ^ self ].
	self target reference: aString.
	self refresh
]

{ #category : #private }
PULinkChange >> updateStatus [
	| response |
	target isExternal ifTrue: [
		response := self httpHead: target url.
		(response isNil)
			ifTrue: [ ^ Array with: 'Unknown' with: 'white' ].
		(response first between: 300 and: 399)
			ifTrue: [ ^ Array with: 'Redirect ' , response first greaseString with: 'yellow' with: response ].
		(response first between: 200 and: 299)
			ifTrue: [ ^ Array with: 'Valid ' , response first greaseString with: 'green' ].
		 ^ Array with: 'Error ' , response first greaseString with: 'red' ].
	^ target isBroken
		ifTrue: [ Array with: 'Error' with: 'error' ]
		ifFalse: [ Array with: 'Valid' with: 'green' ]
]
