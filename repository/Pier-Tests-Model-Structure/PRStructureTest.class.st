Class {
	#name : #PRStructureTest,
	#superclass : #PRDecoratedTest,
	#instVars : [
		'root',
		'folder',
		'child',
		'structure'
	],
	#category : #'Pier-Tests-Model-Structure'
}

{ #category : #testing }
PRStructureTest class >> isAbstract [
	^ true
]

{ #category : #private }
PRStructureTest >> actualClass [
	^ PRStructure
]

{ #category : #private }
PRStructureTest >> actualInstance [
	^ self actualClass named: 'structure'
]

{ #category : #accessing }
PRStructureTest >> child [
	^ child
]

{ #category : #private }
PRStructureTest >> childInstance [
	^ PRPage named: 'child'
]

{ #category : #utilities }
PRStructureTest >> enumerator: aVisitor gives: aCollection [ 
	| children |
	children := aVisitor collect: [ :each | each name ].
	self 
		assert: children = aCollection
		description: children greaseString , ' should be ' , aCollection greaseString
		resumable: true
]

{ #category : #accessing }
PRStructureTest >> folder [
	^ folder
]

{ #category : #private }
PRStructureTest >> folderInstance [
	^ PRPage named: 'folder'
]

{ #category : #accessing }
PRStructureTest >> instance [
	^ structure
]

{ #category : #accessing }
PRStructureTest >> root [
	^ root
]

{ #category : #private }
PRStructureTest >> rootInstance [
	^ PRPage named: 'root'
]

{ #category : #running }
PRStructureTest >> setUp [
	root := self rootInstance.
	folder := self folderInstance.
	child := self childInstance.
	structure := self actualInstance.

	self root addChild: self folder.
	self folder addChild: self child.
	self folder addChild: self structure
]

{ #category : #accessing }
PRStructureTest >> structure [
	^ structure
]

{ #category : #'tests-testing' }
PRStructureTest >> testCanBeChildOf [
	self
		shouldnt:
			[ PRStructure withAllConcreteClassesDo: [ :each | self structure canBeChildOf: each new ] ]
		raise: Error
]

{ #category : #'tests-testing' }
PRStructureTest >> testCanBeParentOf [
	self
		shouldnt:
			[ PRStructure withAllConcreteClassesDo: [ :each | self structure canBeParentOf: each new ] ]
		raise: Error
]

{ #category : #'tests-accessing' }
PRStructureTest >> testCommands [
	self assert: (self structure viewCommandClass includesBehavior: PRCommand).
	self assert: (self structure editCommandClass includesBehavior: PRCommand)
]

{ #category : #'tests-copying' }
PRStructureTest >> testCopyChildren [
	| folderCopy childCopy structureCopy |
	folderCopy := self folder copy.
	childCopy := folderCopy childrenDecoration at: 'child'.
	structureCopy := folderCopy childrenDecoration at: 'structure'.

	self deny: self folder == folderCopy.
	self deny: self child == childCopy.
	self deny: self structure == structureCopy.

	self assert: self folder parent = self root.
	self assert: self child parent = self folder.
	self assert: self structure parent = self folder.

	self assert: folderCopy parent isNil.
	self assert: childCopy parent = folderCopy.
	self assert: structureCopy parent = folderCopy
]

{ #category : #'tests-enumerator' }
PRStructureTest >> testEnumerator [
	self enumerator: self root enumerator gives: #( 'folder' ).
	self enumerator: self root enumerator with gives: #( 'root' 'folder' ).
	self enumerator: self root enumerator all gives: #( 'folder' 'child' 'structure' ).
	self enumerator: self root enumerator with all gives: #( 'root' 'folder' 'child' 'structure' ).
	self enumerator: self root enumerator everything gives: #( 'root' 'folder' 'child' 'structure' )
]

{ #category : #'tests-enumerator' }
PRStructureTest >> testEnumeratorAnySatisfy [
	self assert: (self root enumerator everything
		anySatisfy: [ :each | each = self structure ])
]

{ #category : #'tests-enumerator' }
PRStructureTest >> testEnumeratorDoSeparatedBy [
	| result |
	result := String new.
	self root enumerator everything
		do: [ :each | result := result , each name ]
		separatedBy: [ result := result , ', ' ].
	self assert: result = 'root, folder, child, structure'
]

{ #category : #'tests-enumerator' }
PRStructureTest >> testEnumeratorInjectInto [
	self assert: (self root enumerator everything
		inject: String new
		into: [ :result :each | result , each name ])
			= 'rootfolderchildstructure'
]

{ #category : #'tests-enumerator' }
PRStructureTest >> testEnumeratorReject [
	self
		enumerator: (self root enumerator everything
			reject: [ :each | each = self structure ])
		gives: #( 'root' 'folder' 'child' )
]

{ #category : #'tests-enumerator' }
PRStructureTest >> testEnumeratorSelect [
	self
		enumerator: (self root enumerator everything
			select: [ :each | each = self structure ])
		gives: #( 'structure' )
]

{ #category : #'tests-querying' }
PRStructureTest >> testFindAncestor [
	self assert: (self structure findAncestor: [ :each | each = self structure ]) = self structure.
	self assert: (self structure findAncestor: [ :each | each = self folder ]) = self folder.
	self assert: (self structure findAncestor: [ :each | each = self root ]) = self root.
	self assert: (self structure findAncestor: [ :each | each = self child ]) isNil
]

{ #category : #'tests-querying' }
PRStructureTest >> testFindAncestorIfAbsent [
	self assert: (self structure findAncestor: [ :each | each = self structure ] ifAbsent: [ 123 ]) = self structure.
	self assert: (self structure findAncestor: [ :each | each = self folder ]  ifAbsent: [ 123 ]) = self folder.
	self assert: (self structure findAncestor: [ :each | each = self root ] ifAbsent: [ 123 ]) = self root.
	self assert: (self structure findAncestor: [ :each | each = self child ] ifAbsent: [ 123 ]) = 123
]

{ #category : #'tests-testing' }
PRStructureTest >> testHasChildren [
	self assert: self root hasChildren.
	self assert: self folder hasChildren.
	self deny: self child hasChildren.
	self deny: self structure hasChildren
]

{ #category : #'tests-testing' }
PRStructureTest >> testHasDocument [
	self assert: self root hasDocument.
	self assert: self folder hasDocument.
	self assert: self child hasDocument
]

{ #category : #'tests-testing' }
PRStructureTest >> testHasParent [
	self deny: self root hasParent.
	self assert: self folder hasParent.
	self assert: self child hasParent.
	self assert: self structure hasParent
]

{ #category : #'tests-lookup' }
PRStructureTest >> testIncompleteLookupEmptyName [
	self shouldnt: [ self root lookupIncompletePath: 'alias>@anchor' ] raise: Error
]

{ #category : #'tests-lookup' }
PRStructureTest >> testIncompleteLookupName [
	| lookup |
	lookup := self root lookupIncompletePath: '/folder/zork'.
	self assert: lookup key = self folder.
	self assert: lookup value = 'zork'.
	
	lookup := self root lookupIncompletePath: '/folder/zork/'.
	self assert: lookup key = self folder.
	self assert: lookup value = 'zork'.

	lookup := self structure lookupIncompletePath: '../structure/foo/bar'.
	self assert: lookup key = self structure.
	self assert: lookup value = 'foo'.
	
	lookup := self structure lookupIncompletePath: '../structure/foo/bar/'.
	self assert: lookup key = self structure.
	self assert: lookup value = 'foo'
]

{ #category : #'tests-lookup' }
PRStructureTest >> testIncompleteLookupTitle [
	| lookup |
	lookup := self root lookupIncompletePath: '/Folder/zork'.
	self assert: lookup key = self folder.
	self assert: lookup value = 'zork'.
	
	lookup := self root lookupIncompletePath: '/Folder/zork/'.
	self assert: lookup key = self folder.
	self assert: lookup value = 'zork'.

	lookup := self structure lookupIncompletePath: '../Structure/foo/bar'.
	self assert: lookup key = self structure.
	self assert: lookup value = 'foo'.
	
	lookup := self structure lookupIncompletePath: '../Structure/foo/bar/'.
	self assert: lookup key = self structure.
	self assert: lookup value = 'foo'
]

{ #category : #'tests-testing' }
PRStructureTest >> testIsAncestorOf [
	self assert: (self root isAncestorOf: self root).
	self assert: (self root isAncestorOf: self folder).
	self assert: (self root isAncestorOf: self child).
	self assert: (self root isAncestorOf: self structure).

	self deny: (self folder isAncestorOf: self root).
	self assert: (self folder isAncestorOf: self folder).
	self assert: (self folder isAncestorOf: self child).
	self assert: (self folder isAncestorOf: self structure).

	self deny: (self child isAncestorOf: self root).
	self deny: (self child isAncestorOf: self folder).
	self assert: (self child isAncestorOf: self child).
	self deny: (self child isAncestorOf: self structure).

	self deny: (self structure isAncestorOf: self root).
	self deny: (self structure isAncestorOf: self folder).
	self deny: (self structure isAncestorOf: self child).
	self assert: (self structure isAncestorOf: self structure)
]

{ #category : #'tests-testing' }
PRStructureTest >> testIsFile [
	self deny: self instance isFile
]

{ #category : #'tests-testing' }
PRStructureTest >> testIsRoot [
	self assert: self root isRoot.
	self deny: self folder isRoot.
	self deny: self child isRoot.
	self deny: self structure isRoot
]

{ #category : #'tests-accessing' }
PRStructureTest >> testKernel [
	self
		should: [ self instance kernel ]
		raise: Error
]

{ #category : #'tests-accessing' }
PRStructureTest >> testLevel [
	self assert: self root level = 1.
	self assert: self folder level = 2.
	self assert: self child level = 3.
	self assert: self structure level = 3
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupCaseSensitive [
	| struc |
	struc := self actualInstance 
		name: 'Child';
		title: 'Structure';
		yourself.
	self folder addChild: struc.

	self assert: (self folder lookupPath: 'Child') = struc.
	self assert: (self folder lookupPath: 'CHILD') = self child.
	self assert: (self folder lookupPath: 'Structure') = self structure
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupComposed [
	self assert: (self child lookupPath: '../child/..') = self folder.
	self assert: (self child lookupPath: '../child/../') = self folder.

	self assert: (self child lookupPath: '../structure/..') = self folder.
	self assert: (self child lookupPath: '../structure/../') = self folder.

	self assert: (self child lookupPath: '../structure/../child') = self child.
	self assert: (self child lookupPath: '../structure/../child/') = self child.

	self assert: (self child lookupPath: '../structure/../structure') = self structure.
	self assert: (self child lookupPath: '../structure/../structure/') = self structure
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupComposedTitle [
	self assert: (self child lookupPath: '../Child/..') = self folder.
	self assert: (self child lookupPath: '../Child/../') = self folder.

	self assert: (self child lookupPath: '../Structure/..') = self folder.
	self assert: (self child lookupPath: '../Structure/../') = self folder.

	self assert: (self child lookupPath: '../Structure/../child') = self child.
	self assert: (self child lookupPath: '../structure/../Child/') = self child.

	self assert: (self child lookupPath: '../Structure/../structure') = self structure.
	self assert: (self child lookupPath: '../structure/../Structure/') = self structure
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupEmpty [
	self assert: (self root lookupPath: '') = self root.
	self assert: (self folder lookupPath: '') = self folder.
	self assert: (self child lookupPath: '') = self child.
	self assert: (self structure lookupPath: '') = self structure
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupError [
	self assert: (self root lookupPath: 'unknown') isNil.
	self assert: (self root lookupPath: 'unknown/') isNil.

	self assert: (self root lookupPath: 'zork') isNil.
	self assert: (self root lookupPath: 'zork/') isNil.

	self assert: (self root lookupPath: 'folder/unknown') isNil.
	self assert: (self root lookupPath: 'folder/unknown/') isNil.

	self assert: (self root lookupPath: 'folder/unknown/unknown') isNil.
	self assert: (self root lookupPath: 'folder/unknown/unknown/') isNil.

	self assert: (self root lookupPath: 'folder/instance/unknown') isNil.
	self assert: (self root lookupPath: 'folder/instance/unknown/') isNil
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupErrorIfAbsent [
	self assert: (self root lookupPath: 'unknown' ifAbsent: [ self structure ]) = self structure.
	self assert: (self root lookupPath: 'unknown/' ifAbsent: [ self structure ]) = self structure.

	self assert: (self root lookupPath: 'zork' ifAbsent: [ self structure ]) = self structure.
	self assert: (self root lookupPath: 'zork/' ifAbsent: [ self structure ]) = self structure.

	self assert: (self root lookupPath: 'folder/unknown' ifAbsent: [ self structure ]) = self structure.
	self assert: (self root lookupPath: 'folder/unknown/' ifAbsent: [ self structure ]) = self structure.

	self assert: (self root lookupPath: 'folder/unknown/unknown' ifAbsent: [ self structure ]) = self structure.
	self assert: (self root lookupPath: 'folder/unknown/unknown/' ifAbsent: [ self structure ]) = self structure.

	self assert: (self root lookupPath: 'folder/instance/unknown' ifAbsent: [ self structure ]) = self structure.
	self assert: (self root lookupPath: 'folder/instance/unknown/' ifAbsent: [ self structure ]) = self structure
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupParent [
	self assert: (self root lookupPath: '..') = self root.
	self assert: (self root lookupPath: '../') = self root.

	self assert: (self folder lookupPath: '..') = self root.
	self assert: (self folder lookupPath: '../') = self root.

	self assert: (self child lookupPath: '..') = self folder.
	self assert: (self child lookupPath: '../') = self folder.

	self assert: (self structure lookupPath: '..') = self folder.
	self assert: (self structure lookupPath: '../') = self folder
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupParentParent [
	self assert: (self root lookupPath: '../..') = self root.
	self assert: (self root lookupPath: '../../') = self root.

	self assert: (self folder lookupPath: '../..') = self root.
	self assert: (self folder lookupPath: '../../') = self root.

	self assert: (self child lookupPath: '../..') = self root.
	self assert: (self child lookupPath: '../../') = self root.

	self assert: (self structure lookupPath: '../..') = self root.
	self assert: (self structure lookupPath: '../..') = self root
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupParsing [
	self assert: (PRPathLookup new stream: 'abc' readStream; readNext) = 'abc'.
	self assert: (PRPathLookup new stream: 'abc/' readStream; readNext) = 'abc'.

	self assert: (PRPathLookup new stream: 'abc/def' readStream; readNext) = 'abc'.
	self assert: (PRPathLookup new stream: 'abc/def/' readStream; readNext) = 'abc'.

	self assert: (PRPathLookup new stream: 'abc' readStream; readNext; readNext) = ''.
	self assert: (PRPathLookup new stream: 'abc/' readStream; readNext; readNext) = ''.

	self assert: (PRPathLookup new stream: 'abc/def' readStream; readNext; readNext) = 'def'.
	self assert: (PRPathLookup new stream: 'abc/def/' readStream; readNext; readNext) = 'def'
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupRelative [
	self assert: (self structure lookupPath: '../structure') = self structure.
	self assert: (self structure lookupPath: '../structure/') = self structure.

	self assert: (self structure lookupPath: '../../folder') = self folder.
	self assert: (self structure lookupPath: '../../folder/') = self folder.

	self assert: (self structure lookupPath: '../../folder/structure') = self structure.
	self assert: (self structure lookupPath: '../../folder/structure/') = self structure
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupRelativeTitle [
	self assert: (self structure lookupPath: '../Structure') = self structure.
	self assert: (self structure lookupPath: '../Structure/') = self structure.

	self assert: (self structure lookupPath: '../../Folder') = self folder.
	self assert: (self structure lookupPath: '../../Folder/') = self folder.

	self assert: (self structure lookupPath: '../../Folder/Structure') = self structure.
	self assert: (self structure lookupPath: '../../Folder/Structure/') = self structure
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupRoot [
	self assert: (self root lookupPath: '/') = self root.
	self assert: (self root lookupPath: '/folder') = self folder.
	self assert: (self root lookupPath: '/folder/child') = self child.
	self assert: (self root lookupPath: '/folder/structure') = self structure.

	self assert: (self structure lookupPath: '/') = self root.
	self assert: (self structure lookupPath: '/folder') = self folder.
	self assert: (self structure lookupPath: '/folder/child') = self child.
	self assert: (self structure lookupPath: '/folder/structure') = self structure
]

{ #category : #'tests-lookup' }
PRStructureTest >> testLookupRootTitle [
	self assert: (self root lookupPath: '/Folder') = self folder.
	self assert: (self root lookupPath: '/Folder/Child') = self child.
	self assert: (self root lookupPath: '/Folder/Structure') = self structure.

	self assert: (self structure lookupPath: '/Folder') = self folder.
	self assert: (self structure lookupPath: '/Folder/Child') = self child.
	self assert: (self structure lookupPath: '/Folder/Structure') = self structure
]

{ #category : #'tests-accessing' }
PRStructureTest >> testName [
	self assert: self root name = 'root'.
	self assert: self folder name = 'folder'.
	self assert: self child name = 'child'.
	self assert: self structure name = 'structure'
]

{ #category : #'tests-accessing' }
PRStructureTest >> testParent [
	self assert: self root parent isNil.
	self assert: self folder parent = root.
	self assert: self child parent = folder.
	self assert: self structure parent = folder
]

{ #category : #'tests-accessing' }
PRStructureTest >> testParents [
	self assert: self root parents size = 1.
	self assert: self root parents first = self root.

	self assert: self folder parents size = 2.
	self assert: self folder parents first = self root.
	self assert: self folder parents second = self folder.

	self assert: self child parents size = 3.
	self assert: self child parents first = self root.
	self assert: self child parents second = self folder.
	self assert: self child parents third = self child.

	self assert: self structure parents size = 3.
	self assert: self structure parents first = self root.
	self assert: self structure parents second = self folder.
	self assert: self structure parents third = self structure
]

{ #category : #'tests-reference' }
PRStructureTest >> testReferenceEmpty [
	self assert: (self root relativePathTo: self root) = '.'.
	self assert: (self folder relativePathTo: self folder) = '.'.
	self assert: (self child relativePathTo: self child) = '.'.
	self assert: (self structure relativePathTo: self structure) = '.'.
	
	self assert: (self root relativePathFrom: self root) = '.'.
	self assert: (self folder relativePathFrom: self folder) = '.'.
	self assert: (self child relativePathFrom: self child) = '.'.
	self assert: (self structure relativePathFrom: self structure) = '.'
]

{ #category : #'tests-reference' }
PRStructureTest >> testReferenceError [
	self should: [ self structure relativePathFrom: PRPage new ] raise: PRInvalidKernelError.
	self should: [ PRPage new relativePathFrom: self structure ] raise: PRInvalidKernelError.
	self should: [ self structure relativePathTo: PRPage new ] raise: PRInvalidKernelError.
	self should: [ PRPage new relativePathTo: self structure ] raise: PRInvalidKernelError
]

{ #category : #'tests-reference' }
PRStructureTest >> testReferenceParent [
	self assert: (self folder relativePathTo: self root) = '..'.
	self assert: (self child relativePathTo: self folder) = '..'.
	self assert: (self structure relativePathTo: self folder) = '..'.
	
	self assert: (self root relativePathFrom: self folder) = '..'.
	self assert: (self folder relativePathFrom: self child) = '..'.
	self assert: (self folder relativePathFrom: self structure) = '..'.

	self assert: (self child relativePathTo: self root) = '../..'.
	self assert: (self structure relativePathTo: self root) = '../..'.
	
	self assert: (self root relativePathFrom: self child) = '../..'.
	self assert: (self root relativePathFrom: self structure) = '../..'
]

{ #category : #'tests-reference' }
PRStructureTest >> testReferenceRelative [
	self assert: (self structure relativePathFrom: self child) = '../structure'.
	self assert: (self child relativePathFrom: self structure) = '../child'.
	
	self assert: (self child relativePathTo: self structure) = '../structure'.
	self assert: (self structure relativePathTo: self child) = '../child'
]

{ #category : #'tests-reference' }
PRStructureTest >> testReferenceRoot [
	self assert: (self root absolutePath) = '/'.
	self assert: (self folder absolutePath) = '/folder'.
	self assert: (self child absolutePath) = '/folder/child'.
	self assert: (self structure absolutePath) = '/folder/structure'.

	self assert: (self root relativePathTo: self root) = '.'.
	self assert: (self root relativePathTo: self folder) = 'folder'.
	self assert: (self root relativePathTo: self child) = 'folder/child'.
	self assert: (self root relativePathTo: self structure) = 'folder/structure'.
	
	self assert: (self root relativePathFrom: self root) = '.'.
	self assert: (self folder relativePathFrom: self root) = 'folder'.
	self assert: (self child relativePathFrom: self root) = 'folder/child'.
	self assert: (self structure relativePathFrom: self root) = 'folder/structure'
]

{ #category : #'tests-accessing' }
PRStructureTest >> testRoot [
	self assert: self root root = self root.
	self assert: self folder root = self root.
	self assert: self child root = self root.
	self assert: self structure root = self root
]

{ #category : #'tests-accessing' }
PRStructureTest >> testTags [
	self assert: self structure tags isEmpty.
	self structure tags: #( 'foo' 'bar' ).
	self assert: (self structure tags includes: 'foo').
	self assert: (self structure tags includes: 'bar')
]
