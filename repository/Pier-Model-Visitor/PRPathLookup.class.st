"
I am a visitor used to look up a given path. I am able to lookup absolute and relative paths, following the syntax of unix operating systems.

!Example
=(PRPathLookup
=	start: aStructure
=	path: '/Information/Copyright/..')
=		inspect
"
Class {
	#name : #PRPathLookup,
	#superclass : #PRPath,
	#instVars : [
		'absentBlock',
		'pathElement'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #testing }
PRPathLookup class >> isAbstract [
	^ false
]

{ #category : #'instance creation' }
PRPathLookup class >> start: aStructure path: aString [
	^ self start: aStructure path: aString ifAbsent: [ nil ]
]

{ #category : #'instance creation' }
PRPathLookup class >> start: aStructure path: aString ifAbsent: aBlock [
	^ self new
		stream: aString readStream;
		absentBlock: aBlock;
		lookup: aStructure
]

{ #category : #accessing }
PRPathLookup >> absentBlock [
	^ absentBlock
]

{ #category : #accessing }
PRPathLookup >> absentBlock: aBlock [
	absentBlock := aBlock
]

{ #category : #private }
PRPathLookup >> childNotFound: aStructure [
	self escape: self absentBlock value
]

{ #category : #actions }
PRPathLookup >> lookup: aStructure [
	^ self withEscaper: [
		self stream peek = self class pathDelimiter
			ifTrue: [ self lookupRoot: aStructure ]
			ifFalse: [ self lookupStart: aStructure ].
		self childNotFound: aStructure ]
]

{ #category : #actions }
PRPathLookup >> lookupRoot: aStructure [
	self stream next.
	self visit: aStructure root
]

{ #category : #actions }
PRPathLookup >> lookupStart: aStructure [
	self visit: aStructure
]

{ #category : #accessing }
PRPathLookup >> pathElement [
	^ pathElement
]

{ #category : #accessing }
PRPathLookup >> pathElement: aString [
	pathElement := aString
]

{ #category : #private }
PRPathLookup >> readNext [
	^ self stream upTo: self class pathDelimiter
]

{ #category : #'visiting-decorations' }
PRPathLookup >> visitChildren: anObject [
	"This method does the lookup of the next structure by checking for a child with that name, since this value is hashed it can be done efficiently. If the lookup by name fails, it tries to match the title case-insensitive by iterating through the children. If this fails as well, the message ==#childNotFound:== is sent."

	anObject
		at: self pathElement
		ifPresent: [ :value | ^ self visit: value ].
	anObject children do: [ :each |
		((self pathElement sameAs: each name)
			or: [ self pathElement sameAs: each title ])
				ifTrue: [ ^ self visit: each ] ].
	self childNotFound: anObject decorated
]

{ #category : #'visiting-structure' }
PRPathLookup >> visitStructure: aStructure [
	self stream atEnd
		ifTrue: [ self escape: aStructure ].
	self pathElement: self readNext.
	self pathElement = self class currentStructure
		ifTrue: [ ^ self visit: aStructure ].
	self pathElement = self class parentStructure
		ifTrue: [
			^ self visit: (aStructure isRoot
				ifTrue: [ aStructure ]
				ifFalse: [ aStructure parent ]) ].
	aStructure hasChildren
		ifFalse: [ self childNotFound: aStructure ]
]
