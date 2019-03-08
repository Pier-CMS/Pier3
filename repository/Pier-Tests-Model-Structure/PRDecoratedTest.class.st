Class {
	#name : #PRDecoratedTest,
	#superclass : #PRObjectTest,
	#category : #'Pier-Tests-Model-Structure'
}

{ #category : #testing }
PRDecoratedTest class >> isAbstract [
	^ true
]

{ #category : #private }
PRDecoratedTest >> actualClass [
	^ PRDecorated
]

{ #category : #accessing }
PRDecoratedTest >> decorationWithPriority: anInteger [
	^ PRMockDecoration new
		priority: anInteger;
		yourself
]

{ #category : #'tests-adding' }
PRDecoratedTest >> testAddDecoration [
	| mock1 mock2 index1 index2 |
	mock1 := self decorationWithPriority: 10.
	mock2 := self decorationWithPriority: -5.

	self assert: (self instance addDecoration: mock1) = mock1.
	self assert: self instance = mock1 decorated.
	self assert: (self instance decorations includes: mock1).

	self assert: (self instance addDecoration: mock2) = mock2.
	self assert: self instance = mock2 decorated.
	self assert: (self instance decorations includes: mock2).

	index1 := self instance decorations indexOf: mock1.
	index2 := self instance decorations indexOf: mock2.
	self assert: index1 > index2.

	self should: [ self instance addDecoration: mock1 ] raise: PRDecorationError.
	self should: [ self instance addDecoration: mock2 ] raise: PRDecorationError.
	self assert: (self instance decorations includes: mock2).
	self assert: (self instance decorations includes: mock2)
]

{ #category : #'tests-adding' }
PRDecoratedTest >> testAddDecorationIfPresent [
	| mock1 mock2 index1 index2 |
	mock1 := self decorationWithPriority: 10.
	mock2 := self decorationWithPriority: -5.

	self assert: (self instance
		addDecoration: mock1
		ifPresent: [ :value | self assert: false ]) = mock1.
	self assert: self instance = mock1 decorated.
	self assert: (self instance decorations includes: mock1).

	self assert: (self instance
		addDecoration: mock2
		ifPresent: [ :value | self assert: false ]) = mock2.
	self assert: self instance = mock2 decorated.
	self assert: (self instance decorations includes: mock2).

	index1 := self instance decorations indexOf: mock1.
	index2 := self instance decorations indexOf: mock2.
	self assert: index1 > index2.

	self assert: (self instance
		addDecoration: mock1
		ifPresent: [ :value | nil ]) isNil.
	self assert: (self instance
		addDecoration: mock2
		ifPresent: [ :value | nil ]) isNil.
	self assert: (self instance decorations includes: mock1).
	self assert: (self instance decorations includes: mock2)
]

{ #category : #'tests-copying' }
PRDecoratedTest >> testCopyDecorations [
	| decoration copiedInstance copiedDecoration |
	decoration := self instance addDecoration: (self decorationWithPriority: SmallInteger minVal).
	copiedInstance := self instance copy.
	copiedDecoration := copiedInstance decorations first.

	self deny: self instance == copiedInstance.
	self deny: decoration == copiedDecoration.

	self assert: self instance decorations first = decoration.
	self assert: self instance = decoration decorated.

	self assert: copiedInstance decorations first = copiedDecoration.
	self assert: copiedInstance = copiedDecoration decorated
]

{ #category : #'tests-querying' }
PRDecoratedTest >> testDecorationOfClass [
	| mock |
	self should: [ self instance decorationOfClass: PRMockDecoration ] raise: PRDecorationError.
	self instance addDecoration: (mock := self decorationWithPriority: 1).
	self assert: (self instance decorationOfClass: PRMockDecoration) = mock
]

{ #category : #'tests-querying' }
PRDecoratedTest >> testDecorationOfClassIfAbsent [
	| mock |
	self assert: (self instance decorationOfClass: PRMockDecoration ifAbsent: [ nil ]) isNil.
	self instance addDecoration: (mock := self decorationWithPriority: 1).
	self assert: (self instance decorationOfClass: PRMockDecoration) = mock
]

{ #category : #'tests-enumerating' }
PRDecoratedTest >> testDecorationsDo [
	| first second |
	self instance
		addDecoration: (first := self decorationWithPriority: SmallInteger minVal);
		addDecoration: (second := self decorationWithPriority: SmallInteger maxVal).
	self instance decorationsDo: [ :each |
		(first notNil and: [ second notNil and: [ each = first ] ])
			ifTrue: [ first := nil ].
		(first isNil and: [ second notNil and: [ each = second ] ])
			ifTrue: [ second := nil ] ].
	self assert: first isNil.
	self assert: second isNil
]

{ #category : #'tests-enumerating' }
PRDecoratedTest >> testDecorationsDoOwnerDo [
	| instance first second |
	instance := self instance
		addDecoration: (first := self decorationWithPriority: SmallInteger minVal);
		addDecoration: (second := self decorationWithPriority: SmallInteger maxVal);
		yourself.
	self instance
		decorationsDo: [ :each |
			(first notNil and: [ instance notNil and: [ second notNil and: [ each = first ] ] ])
				ifTrue: [ first := nil ].
			(first isNil and: [ instance isNil and: [ second notNil and: [ each = second ] ] ])
				ifTrue: [ second := nil ] ]
		ownerDo: [ :each |
			self assert: first isNil.
			self assert: second notNil.
			self assert: instance notNil.
			instance := nil ].
	self assert: first isNil.
	self assert: second isNil.
	self assert: instance isNil
]

{ #category : #tests }
PRDecoratedTest >> testInitialized [
	self assert: (self instance decorations isKindOf: Collection)
]

{ #category : #'tests-removing' }
PRDecoratedTest >> testRemoveDecoration [
	| mock1 mock2 |
	self instance
		addDecoration: (mock1 := self decorationWithPriority: 1);
		addDecoration: (mock2 := self decorationWithPriority: 2).

	self assert: (self instance removeDecoration: mock1) = mock1.
	self deny: (self instance decorations includes: mock1).
	self assert: (self instance decorations includes: mock2).

	self assert: (self instance removeDecoration: mock2) = mock2.
	self deny: (self instance decorations includes: mock1).
	self deny: (self instance decorations includes: mock2).

	self should: [ self instance removeDecoration: mock2 ] raise: PRDecorationError
]

{ #category : #'tests-removing' }
PRDecoratedTest >> testRemoveDecorationIfAbsent [
| mock1 mock2 |
	self instance
		addDecoration: (mock1 := self decorationWithPriority: 1);
		addDecoration: (mock2 := self decorationWithPriority: 2).

	self assert: (self instance removeDecoration: mock1 ifAbsent: [ nil ]) = mock1.
	self deny: (self instance decorations includes: mock1).
	self assert: (self instance decorations includes: mock2).

	self assert: (self instance removeDecoration: mock2 ifAbsent: [ nil ]) = mock2.
	self deny: (self instance decorations includes: mock1).
	self deny: (self instance decorations includes: mock2).

	self assert: (self instance removeDecoration: mock2 ifAbsent: [ nil ]) isNil
]
