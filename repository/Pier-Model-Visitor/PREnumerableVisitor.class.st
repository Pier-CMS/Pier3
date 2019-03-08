Class {
	#name : #PREnumerableVisitor,
	#superclass : #PRPluggableVisitor,
	#instVars : [
		'structure'
	],
	#category : #'Pier-Model-Visitor'
}

{ #category : #'instance creation' }
PREnumerableVisitor class >> on: aStructure [
	^ self new structure: aStructure
]

{ #category : #enumerating }
PREnumerableVisitor >> anySatisfy: aBlock [
	"Evaluate aBlock for every structure visited by the receiver. If aBlock returns true for any element return true. Otherwise return false."

	self do: [ :each | 
		(aBlock value: each)
			ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #enumerating }
PREnumerableVisitor >> collect: aBlock [
	"Evaluate aBlock for every structure visited by the receiver and answer a collection of the results."

	^ Array streamContents: [ :stream |
		self do: [ :each |
			stream nextPut: (aBlock value: each) ] ]
]

{ #category : #accessing }
PREnumerableVisitor >> contents [
	"Answer a collection of all elements that have been visited."

	^ self collect: [ :each | each ]
]

{ #category : #enumerating }
PREnumerableVisitor >> detect: aBlock [ 
	"Evaluate aBlock for every structure visited by the receiver. 
	Answer the first element for which aBlock evaluates to true."
	
	^ self detect: aBlock ifNone: [GRObject error: 'Object is not in the collection']
]

{ #category : #enumerating }
PREnumerableVisitor >> detect: aBlock ifNone: exceptionBlock [
	"Evaluate aBlock for every structure visited by the receiver.  
	Answer the first element for which aBlock evaluates to true. If none  
	evaluate to true, then evaluate the argument, exceptionBlock."

	self do: [:each | (aBlock value: each) ifTrue: [^ each]].
	^ exceptionBlock value
]

{ #category : #enumerating }
PREnumerableVisitor >> do: aBlock [
	"Evaluate aBlock for every structure visited by the receiver."

	self setBlock: aBlock; start: structure; setBlock: nil
]

{ #category : #enumerating }
PREnumerableVisitor >> do: aBlock separatedBy: aSeparatorBlock [
	"Evaluate aBlock for every structure visited by the receiver, and evaluate aSeparatorBlock between."

	| first |
	first := true.
	self do: [ :each |
		first
			ifTrue: [ first := false ]
			ifFalse: [ aSeparatorBlock value ].
		aBlock value: each ]
]

{ #category : #enumerating }
PREnumerableVisitor >> inject: anObject into: aBlock [
	"Accumulate a running value associated with evaluating the argument aBlock with the current value of the argument anObject and the receiver as block arguments."

	| next |
	next := anObject.
	self do: [ :each | next := aBlock value: next value: each ].
	^ next
]

{ #category : #enumerating }
PREnumerableVisitor >> reject: aBlock [
	"Evaluate aBlock for every structure visited by the receiver and answer a collection for which aBlock evaluates to ==false==."

	^ self select: [ :each | (aBlock value: each) not ]
]

{ #category : #enumerating }
PREnumerableVisitor >> select: aBlock [
	"Evaluate aBlock for every structure visited by the receiver and answer a collection for which aBlock evaluates to ==true==."

	^ Array streamContents: [ :stream |
		self do: [ :each |
			(aBlock value: each)
				ifTrue: [ stream nextPut: each ] ] ]
]

{ #category : #accessing }
PREnumerableVisitor >> size [
	"Answer the number of elements."

	| tally |
	tally := 0.
	self do: [ :each | tally := tally + 1 ].
	^ tally
]

{ #category : #accessing }
PREnumerableVisitor >> structure: aStructure [
	structure := aStructure
]
