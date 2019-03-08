Class {
	#name : #PRCaseTest,
	#superclass : #PRStructureTest,
	#category : #'Pier-Tests-Model-Structure'
}

{ #category : #testing }
PRCaseTest class >> isAbstract [
	^ true
]

{ #category : #private }
PRCaseTest >> actualClass [
	^ PRCase
]

{ #category : #private }
PRCaseTest >> actualInstance [
	^ super actualInstance
		contents: '!A Title
-A simple List-Element';
		yourself

]

{ #category : #tests }
PRCaseTest >> testContents [
	self structure contents: nil.
	self assert: self structure contents = ''.

	self structure contents: ''.
	self assert: self structure contents = ''.

	self structure contents: 'Foo'.
	self assert: self structure contents = 'Foo'
]

{ #category : #tests }
PRCaseTest >> testDocument [
	self structure document: PRDocument new.
	self assert: self structure document = PRDocument new.
	self assert: self structure contents = ''.
	
	structure := self actualClass new.
	self assert: structure document = structure defaultDocument
]

{ #category : #'tests-visiting' }
PRCaseTest >> testFullTextSearch [
	| matches |
	matches := self root fullTextSearch
		subString: 'title';
		caseSensitive: true;
		contents.
	self assert: matches size = 0.

	matches := self root fullTextSearch
		subString: 'Title';
		caseSensitive: true;
		contents.
	self assert: matches size = 1.
	self assert: matches first = self structure.

	matches := self root fullTextSearch
		subString: 'title';
		caseSensitive: false;
		contents.
	self assert: matches size = 1.
	self assert: matches first = self structure.

	matches := self root fullTextSearch
		subString: 'list-element';
		caseSensitive: true;
		contents.
	self assert: matches size = 0.

	matches := self root fullTextSearch
		subString: 'List-Element';
		caseSensitive: true;
		contents.
	self assert: matches size = 1.
	self assert: matches first = self structure.

	matches := self root fullTextSearch
		subString: 'list-element';
		caseSensitive: false;
		contents.
	self assert: matches size = 1.
	self assert: matches first = self structure
]

{ #category : #'tests-testing' }
PRCaseTest >> testHasDocument [
	self assert: self instance hasDocument
]

{ #category : #'tests-visiting' }
PRCaseTest >> testIncomingReferences [
	| matches |
	matches := self root incomingReferences
		to: self structure;
		collect: [ :each | each owner ].
	self assert: matches size = 0.

	self root contents: '*/folder/structure*'.
	matches := self root incomingReferences
		to: self structure;
		collect: [ :each | each owner ].
	self assert: matches size = 1.
	self assert: matches first = self root.

	self folder contents: '*/folder/structure|embedded=true*'.
	matches := self root incomingReferences
		to: self structure;
		collect: [ :each | each owner ].
	self assert: matches size = 2.
	self assert: matches first = self root.
	self assert: matches second = self folder
]

{ #category : #'tests-visiting' }
PRCaseTest >> testOutgoingReferences [
	| matches |
	self structure contents: ''.
	matches := self structure outgoingReferences
		collect: [ :each | each target ].
	self assert: matches size = 0.

	self structure contents: '*/*'.
	matches := self structure outgoingReferences
		collect: [ :each | each target ].
	self assert: matches size = 1.
	self assert: matches first = self root.

	self structure contents: '*.*'.
	matches := self structure outgoingReferences
		collect: [ :each | each target ].
	self assert: matches size = 1.
	self assert: matches first = self structure.

	self structure contents: '*.* */* */*'.
	matches := self structure outgoingReferences
		collect: [ :each | each target ].
	self assert: matches size = 3.
	self assert: matches first = self structure.
	self assert: matches second = self root.
	self assert: matches third = self root
]

{ #category : #tests }
PRCaseTest >> testPlainText [
	self structure contents: nil.
	self assert: self structure plainText = ''.

	self structure contents: ''.
	self assert: self structure plainText = ''.

	self structure contents: 'Foo'.
	self assert: self structure plainText = 'Foo'
]
