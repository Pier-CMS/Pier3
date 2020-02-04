Class {
	#name : #PRDeepRenderer,
	#superclass : #PRRenderer,
	#instVars : [
		'visited'
	],
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #initialization }
PRDeepRenderer >> initialize [
	super initialize.
	visited := OrderedCollection new
]

{ #category : #private }
PRDeepRenderer >> linkRendererFor: aLink [
	"Answer an instance of the most appropriate renderer for this link. If the link is internal and embedded, avoid the embedding and simply create a reference."

	| class |
	class := aLink isBroken
		ifTrue: [ PRBrokenRenderer ]
		ifFalse: [
			(aLink isEmbedded not
				or: [ aLink isInternal
				and: [ aLink target hasDocument
				and: [ visited includes: aLink target ] ] ])
					ifTrue: [ PRReferenceRenderer ]
					ifFalse: [ PREmbeddedRenderer ] ].
	^ class parent: self
]

{ #category : #visiting }
PRDeepRenderer >> start: anObject [
	visited := OrderedCollection new.
	super start: anObject
]

{ #category : #public }
PRDeepRenderer >> structure: aStructure during: aBlock [
	"Always go through this method when rendering a structure. This allows the system to remember the currently rendered structures and avoid deadly recursion as well as enables plugins to intercept when the different parts of a page are rendered."
	
	visited addLast: aStructure.
	^ aBlock ensure: [ visited removeLast ]
]

{ #category : #'visiting-structure' }
PRDeepRenderer >> visitStructure: aStructure [
	self 
		structure: aStructure
		during: [ self visit: aStructure document ]
]

{ #category : #private }
PRDeepRenderer >> visitsOf: anObject [
	^ visited occurrencesOf: anObject
]
