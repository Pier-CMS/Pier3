"
I am a pluggable visitor to quickly look for matching text in a subtree of structures.

!Example
The following example opens an inspector on all structures with the text ==foo==:
=(PRFullTextSearch 
=	from: aStructure
=	find: 'foo'
=	caseSensitive: false)
=		inspect
"
Class {
	#name : #PRFullTextSearch,
	#superclass : #PREnumerableVisitor,
	#instVars : [
		'acceptToken',
		'rejectToken',
		'caseSensitive'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #testing }
PRFullTextSearch class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRFullTextSearch >> acceptToken: aString [
	"Add the token aString to be accepted."
	
	aString isEmpty
		ifFalse: [ acceptToken add: aString ]
]

{ #category : #accessing }
PRFullTextSearch >> caseSensitive: aBoolean [
	"Set if the search text is case sensitive or not."

	caseSensitive := aBoolean
]

{ #category : #initialization }
PRFullTextSearch >> initialize [
	super initialize.
	acceptToken := Set new.
	rejectToken := Set new.
	caseSensitive := false
]

{ #category : #accessing }
PRFullTextSearch >> rejectToken: aString [
	"Add the token aString to be rejected."

	aString isEmpty
		ifFalse: [ rejectToken add: aString ]
]

{ #category : #private }
PRFullTextSearch >> search: aShortString in: aLongString [
	"In some older versions of Pharo some ByteString/WideString combinations throw an error. Avoid those."

	^ [ (aLongString findString: aShortString startingAt: 1 caseSensitive: caseSensitive) > 0 ]
		on: Error 
		do: [ :err | false ]
]

{ #category : #visiting }
PRFullTextSearch >> start: anObject [
	(acceptToken isEmpty and: [ rejectToken isEmpty ])
		ifTrue: [ ^ self ].
	super start: anObject
]

{ #category : #deprecated }
PRFullTextSearch >> subString: aString [
	self acceptToken: aString
]

{ #category : #'visiting-decoration' }
PRFullTextSearch >> visitChildren: anObject [
	self visitAll: anObject children
]

{ #category : #'visiting-structure' }
PRFullTextSearch >> visitStructure: aStructure [
	| accepted string |
	accepted := false.
	aStructure magritteDescription do: [ :description |
		description isSearchable ifTrue: [
			string := description toString: (aStructure readUsing: description).
			(rejectToken anySatisfy: [ :token | self search: token in: string ])
				ifTrue: [ ^ self ].
			accepted := accepted
				or: [ acceptToken allSatisfy: [ :token | self search: token in: string ] ] ] ].
	(accepted or: [ acceptToken isEmpty ])
		ifTrue: [ block value: aStructure ]
]
