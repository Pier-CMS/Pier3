Class {
	#name : #PROrderCommandTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PROrderCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PROrderCommandTest >> actualClass [
	^ PROrderCommand
]

{ #category : #accessing }
PROrderCommandTest >> children [
	^ self context enumerator contents
]

{ #category : #accessing }
PROrderCommandTest >> childrenNames [
	^ self children collect: [ :each | each name ]
]

{ #category : #private }
PROrderCommandTest >> structureInstance [
	^ super structureInstance
		addChild: (PRPage named: 'a');
		addChild: (PRPage named: 'b');
		addChild: (PRPage named: 'c');
		yourself
]

{ #category : #'tests-setup' }
PROrderCommandTest >> testDefaultOrder [
	self assert: self childrenNames = #( 'a' 'b' 'c' ).
	self assert: (self command class isValidIn: self context)
]

{ #category : #tests }
PROrderCommandTest >> testInitialized [
	self children
		with: self command structures
		do: [ :a :b | self assert: a = b ]
]

{ #category : #tests }
PROrderCommandTest >> testReorderBasic [
	self command structures
		swap: 1 with: 3.
	self command execute.
	self assert: self childrenNames = #( 'c' 'b' 'a' )
]

{ #category : #tests }
PROrderCommandTest >> testReorderWithConcurrentAdd [
	self command structures
		swap: 1 with: 3.
	self structure childrenDecoration
		add: (PRPage named: 'd').
	self command execute.
	self assert: self childrenNames = #( 'c' 'b' 'a' 'd' )
]

{ #category : #tests }
PROrderCommandTest >> testReorderWithConcurrentDelete [
	self command structures
		swap: 1 with: 3.
	self structure childrenDecoration
		remove: self children first.
	self command execute.
	self assert: self childrenNames = #( 'c' 'b' )
]
