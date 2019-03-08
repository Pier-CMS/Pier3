Class {
	#name : #PRMoveCommandTest,
	#superclass : #PRLocationCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PRMoveCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRMoveCommandTest >> actualClass [
	^ PRMoveCommand
]

{ #category : #tests }
PRMoveCommandTest >> testInitialized [
	super testInitialized.
	self assert: self structure name = self command name
]

{ #category : #tests }
PRMoveCommandTest >> testLinkAbsolute [
	self command root contents: '*/command*'.
	self command target: (self command root childrenDecoration
		at: 'folder').
	self command name: 'other'.
	self command execute.
	self assert: self command root contents = '*/folder/other*'
]

{ #category : #tests }
PRMoveCommandTest >> testLinkInside [
	self command structure contents: '*../folder*'.
	self command target: (self command root childrenDecoration
		at: 'folder').
	self command execute.
	self assert: self command structure contents =  '*..*'
]

{ #category : #tests }
PRMoveCommandTest >> testLinkRelative [
	self command root contents: '*command*'.
	self command target: (self command root childrenDecoration
		at: 'folder').
	self command name: 'other'.
	self command execute.
	self assert: self command root contents = '*folder/other*'
]

{ #category : #tests }
PRMoveCommandTest >> testMove [
	self command target: self command root.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: (self command root childrenDecoration
		includes: self structure name)
]

{ #category : #tests }
PRMoveCommandTest >> testMoveIntoChild [
	self command target: self structure.
	self
		should: [ self command execute ]
		raise: PRInvalidNestingError.
	self assert: (self structure parent childrenDecoration
		includes: self structure name)
]

{ #category : #tests }
PRMoveCommandTest >> testMoveIntoFolder [
	self command target: (self command root childrenDecoration
		at: 'folder').
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self deny: (self command root childrenDecoration
		includes: self structure name).
	self assert: ((self command root childrenDecoration
		at: 'folder') childrenDecoration
			includes: self structure name)
]

{ #category : #tests }
PRMoveCommandTest >> testRename [
	self command name: 'foo'.
	self
		shouldnt: [ self command execute ]
		raise: PRConflictingNameError.
	self deny: (self structure parent childrenDecoration
		includes: 'command').
	self assert: (self structure parent childrenDecoration
		includes: 'foo')
]

{ #category : #tests }
PRMoveCommandTest >> testRenameExisting [
	self command name: 'folder'.
	self
		should: [ self command execute ]
		raise: PRConflictingNameError.
	self assert: (self structure parent childrenDecoration
		includes: 'command').
	self assert: (self structure parent childrenDecoration
		includes: 'folder')
]

{ #category : #tests }
PRMoveCommandTest >> testRenameOrder [
	self kernel root
		addChild: (PRPage named: 'other').
	self assert: (self kernel root enumerator
		collect: [ :each | each name ])
			= #('folder' 'command' 'other').

	self command name: 'renamed'.
	self
		shouldnt: [ self command execute ]
		raise: PRConflictingNameError.
	self assert: (self kernel root enumerator
		collect: [ :each | each name ])
			= #('folder' 'renamed' 'other')
]
