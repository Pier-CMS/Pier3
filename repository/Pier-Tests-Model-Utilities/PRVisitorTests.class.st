Class {
	#name : #PRVisitorTests,
	#superclass : #TestCase,
	#instVars : [
		'root',
		'folder',
		'child1',
		'child2'
	],
	#category : #'Pier-Tests-Model-Utilities'
}

{ #category : #running }
PRVisitorTests >> setUp [
	root := PRPage named: 'root'.
	folder := PRPage named: 'folder'.
	child1 := PRPage named: 'child1'.
	child2 := PRPage named: 'child2'.

	root addChild: folder.
	folder addChild: child1.
	folder addChild: child2
]

{ #category : #'tests-outgoing' }
PRVisitorTests >> testEnumerableDetect [
	self assert: (root enumerator all detect: [ :each | each name = 'child2']) = child2.
	self should: [root enumerator detect: [ : each | each name = 'child2']] raise: GRObject defaultErrorClass.
	self shouldnt: [root enumerator detect: [ : each | each name = 'child2'] ifNone: [nil]] raise: GRObject defaultErrorClass
]

{ #category : #'tests-incoming' }
PRVisitorTests >> testIncomingReferencesMultiple [
	| matched |
	root contents: '*folder*'.
	folder contents: '*child1* *child2*'.
	child1 contents: '*/*'.
	child2 contents: ''.

	matched := root incomingReferences
		toAll: (Array with: root with: folder);
		collect: [ :each | each owner ].
	self assert: (matched collect: [ :each | each name ]) = #( 'root' 'child1' ).
	matched := folder incomingReferences
		toAll: (Array with: root with: folder);
		collect: [ :each | each owner ].
	self assert: (matched collect: [ :each | each name ]) = #( 'child1' ).
	matched := folder incomingReferences
		toAll: (Array with: child1 with: child2);
		collect: [ :each | each owner ].
	self assert: (matched collect: [ :each | each name ]) = #( 'folder' 'folder' )
]

{ #category : #'tests-incoming' }
PRVisitorTests >> testIncomingReferencesSingle [
	| matched |
	root contents: '*folder*'.
	folder contents: '*child1* *child2*'.
	child1 contents: '*/*'.
	child2 contents: ''.

	matched := root incomingReferences
		to: root;
		collect: [ :each | each owner ].
	self assert: (matched collect: [ :each | each name ]) = #( 'child1' ).
	matched := root incomingReferences
		to: folder;
		collect: [ :each | each owner ].
	self assert: (matched collect: [ :each | each name ]) = #( 'root' ).
	matched := root incomingReferences
		to: child1;
		collect: [ :each | each owner ].
	self assert: (matched collect: [ :each | each name ]) = #( 'folder' ).
	matched := root incomingReferences
		to: child2;
		collect: [ :each | each owner ].
	self assert: (matched collect: [ :each | each name ]) = #( 'folder' )
]

{ #category : #'tests-outgoing' }
PRVisitorTests >> testOutgoingReferencesContinue [
	| matched |
	root contents: '*folder|embedded=true*'.
	folder contents: '*child1|embedded=true* *child2|embedded=true*'.
	child1 contents: '*/|embedded=true*'.
	child2 contents: ''.

	matched := root outgoingReferences
		continue: [ :each | false ];
		collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'folder' ).
	matched := root outgoingReferences
		continue: [ :each | each owner = root ];
		collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'folder' 'child1' 'child2' ).
	matched := root outgoingReferences
		continue: [ :each | each target ~= child1 ];
		collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'folder' 'child1' 'child2' )
]

{ #category : #'tests-outgoing' }
PRVisitorTests >> testOutgoingReferencesEmbedded [
	| matched |
	root contents: '*folder|embedded=true*'.
	folder contents: '*child1|embedded=true* *child2|embedded=true*'.
	child1 contents: '*/|embedded=true*'.
	child2 contents: ''.

	matched := root outgoingReferences collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'folder' 'child1' 'root' 'child2' ).
	matched := folder outgoingReferences collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'child1' 'root' 'folder' 'child2' ).
	matched := child1 outgoingReferences collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'root' 'folder' 'child1' 'child2' ).
	matched := child2 outgoingReferences collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( )
]

{ #category : #'tests-outgoing' }
PRVisitorTests >> testOutgoingReferencesStandard [
	| matched |
	root contents: '*folder*'.
	folder contents: '*child1* *child2*'.
	child1 contents: '*/*'.
	child2 contents: ''.

	matched := root outgoingReferences collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'folder' ).
	matched := folder outgoingReferences collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'child1' 'child2' ).
	matched := child1 outgoingReferences collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( 'root' ).
	matched := child2 outgoingReferences collect: [ :each | each target ].
	self assert: (matched collect: [ :each | each name ]) = #( )
]

{ #category : #'tests-search' }
PRVisitorTests >> testSearchCaseSensitive [
	| match |
	root contents: 'struct 1 foo'.
	folder contents: 'struct 2 bar'.
	child1 contents: 'struct 3 zork'.
	child2 contents: 'struct 4 plonk'.

	match := root fullTextSearch subString: 'Bar'; caseSensitive: true.
	self assert: (match collect: [ :each | each name ]) = #( ).
	match := root fullTextSearch subString: 'bar'; caseSensitive: true.
	self assert: (match collect: [ :each | each name ]) = #( 'folder' ).

	match := root fullTextSearch subString: 'Bar'; caseSensitive: false.
	self assert: (match collect: [ :each | each name ]) = #( 'folder' ).
	match := root fullTextSearch subString: 'bar'; caseSensitive: false.
	self assert: (match collect: [ :each | each name ]) = #( 'folder' ).

	match := root fullTextSearch subString: 'Bar'.
	self assert: (match collect: [ :each | each name ]) = #( 'folder' ).
	match := root fullTextSearch subString: 'bar'.
	self assert: (match collect: [ :each | each name ]) = #( 'folder' )
]

{ #category : #'tests-search' }
PRVisitorTests >> testSearchContents [
	| match |
	root contents: 'struct 1 foo'.
	folder contents: 'struct 2 bar'.
	child1 contents: 'struct 3 zork'.
	child2 contents: 'struct 4 plonk'.

	match := root fullTextSearch subString: 'foo'.
	self assert: (match collect: [ :each | each name ]) = #( 'root' ).
	match := root fullTextSearch subString: 'bar'.
	self assert: (match collect: [ :each | each name ]) = #( 'folder' ).
	match := root fullTextSearch subString: 'zork'.
	self assert: (match collect: [ :each | each name ]) = #( 'child1' ).
	match := root fullTextSearch subString: 'plonk'.
	self assert: (match collect: [ :each | each name ]) = #( 'child2' )
]

{ #category : #'tests-search' }
PRVisitorTests >> testSearchMultiple [
	| match |
	root contents: 'struct 1 foo'.
	folder contents: 'struct 2 bar'.
	child1 contents: 'struct 3 zork'.
	child2 contents: 'struct 4 plonk'.

	match := root fullTextSearch subString: '1'.
	self assert: (match collect: [ :each | each name ]) = #( 'root' 'child1' ).
	match := root fullTextSearch subString: '2'.
	self assert: (match collect: [ :each | each name ]) = #( 'folder' 'child2' )
]

{ #category : #'tests-search' }
PRVisitorTests >> testSearchMultipleSubstrings [
	| match |
	root contents: 'struct 1 parent'.
	folder contents: 'struct 2 folder'.
	child1 contents: 'struct 3 folder''s first child'.
	child2 contents: 'struct 4 folder''s second child'.
	match := root fullTextSearch subString: 'folder'.
	match subString: 'child'.
	self assert: (match collect: [ :each | each name ]) = #('child1' 'child2').
	match := root fullTextSearch subString: 'struct'.
	match subString: 'not-found'.
	self assert: match size = 0
]

{ #category : #'tests-search' }
PRVisitorTests >> testSearchNonRoot [
	| match |
	root contents: 'struct 1 foo'.
	folder contents: 'struct 2 bar'.
	child1 contents: 'struct 3 zork'.
	child2 contents: 'struct 4 plonk'.

	match := root fullTextSearch subString: 'plonk'.
	self assert: (match collect: [ :each | each name ]) = #( 'child2'  ).
	match := folder fullTextSearch subString: 'plonk'.
	self assert: (match collect: [ :each | each name ]) = #( 'child2'  ).
	match := child1 fullTextSearch subString: 'plonk'.
	self assert: (match collect: [ :each | each name ]) = #(  ).
	match := child2 fullTextSearch subString: 'plonk'.
	self assert: (match collect: [ :each | each name ]) = #( 'child2' )
]

{ #category : #'tests-search' }
PRVisitorTests >> testSearchTitle [
	| match |
	root contents: 'struct 1 foo'.
	folder contents: 'struct 2 bar'.
	child1 contents: 'struct 3 zork'.
	child2 contents: 'struct 4 plonk'.

	match := root fullTextSearch subString: 'root'.
	self assert: (match collect: [ :each | each name ]) = #( 'root' ).
	match := root fullTextSearch subString: 'folder'.
	self assert: (match collect: [ :each | each name ]) = #( 'folder' ).
	match := root fullTextSearch subString: 'child1'.
	self assert: (match collect: [ :each | each name ]) = #( 'child1' ).
	match := root fullTextSearch subString: 'child2'.
	self assert: (match collect: [ :each | each name ]) = #( 'child2' )
]
