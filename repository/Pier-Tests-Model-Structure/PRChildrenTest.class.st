Class {
	#name : #PRChildrenTest,
	#superclass : #PRDecorationTest,
	#category : #'Pier-Tests-Model-Structure'
}

{ #category : #testing }
PRChildrenTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRChildrenTest >> actualClass [
	^ PRChildren
]

{ #category : #private }
PRChildrenTest >> firstChildInstance [
	^ PRPage named: 'child1'
]

{ #category : #private }
PRChildrenTest >> secondChildInstance [
	^ PRPage named: 'child2'
]

{ #category : #'tests-actions' }
PRChildrenTest >> testAdd [
	| child1 child2 |
	child1 := self firstChildInstance.
	self assert: (self decoration add: child1) = child1.
	self assert: self decorated = child1 parent.

	child2 := self secondChildInstance.
	self assert: (self decoration add: child2) = child2.
	self assert: self decorated = child2 parent
]

{ #category : #'tests-accessing' }
PRChildrenTest >> testAt [
	| child1 child2 |
	self decoration
		add: (child1 := self firstChildInstance);
		add: (child2 := self secondChildInstance).

	self assert: (self decoration at: child1 name) = child1.
	self assert: (self decoration at: child2 name) = child2.
	self should: [ self decoration at: 'zork' ] raise: Error
]

{ #category : #'tests-accessing' }
PRChildrenTest >> testAtIfAbsent [
	| child1 child2 |
	self decoration
		add: (child1 := self firstChildInstance);
		add: (child2 := self secondChildInstance).

	self assert: (self decoration at: child1 name ifAbsent: [ nil ]) = child1.
	self assert: (self decoration at: child2 name ifAbsent: [ nil ]) = child2.
	self assert: (self decoration at: 'zork' ifAbsent: [ nil ]) isNil
]

{ #category : #'tests-accessing' }
PRChildrenTest >> testAtIfPresent [
	| child1 child2 |
	self decoration
		add: (child1 := self firstChildInstance);
		add: (child2 := self secondChildInstance).

	self assert: (self decoration
		at: child1 name
		ifPresent: [ :val | val ]) = child1.
	self assert: (self decoration
		at: child2 name
		ifPresent: [ :val | 'zork' ]) = 'zork'.
	self assert: (self decoration
		at: 'zork'
		ifPresent: [ :val | self assert: false ]) isNil
]

{ #category : #'tests-accessing' }
PRChildrenTest >> testIncludes [
	| child1 child2 |
	self decoration
		add: (child1 := self firstChildInstance);
		add: (child2 := self secondChildInstance).

	self assert: (self decoration includes: child1 name).
	self assert: (self decoration includes: child2 name).
	self deny: (self decoration includes: 'zork')
]

{ #category : #'tests-testing' }
PRChildrenTest >> testIsEmpty [
	self assert: self decoration isEmpty.
	self decoration add: self firstChildInstance.
	self deny: self decoration isEmpty
]

{ #category : #'tests-actions' }
PRChildrenTest >> testRemove [
	| child1 child2 |
	self decoration
		add: (child1 := self firstChildInstance);
		add: (child2 := self secondChildInstance).
	self assert: (self decoration remove: child1) = child1.
	self assert: (self decoration remove: child2) = child2.
	self assert: (self decoration isEmpty).
	self assert: (self decoration decorated isNil)
]

{ #category : #'tests-actions' }
PRChildrenTest >> testRemoveLast [
	"Tests that the children decoration is properly removed if the last child has been removed from the decoration."

	| child |
	self decoration
		add: (child := self firstChildInstance).
	self decoration
		remove: child.
	self decorated
		decorationOfClass: self actualClass
		ifAbsent: [ ^ self ].
	self assert: false
]

{ #category : #'tests-accessing' }
PRChildrenTest >> testSize [
	self assert: self decoration size = 0.
	self decoration
		add: self firstChildInstance;
		add: self secondChildInstance.
	self assert: self decoration size = 2
]
