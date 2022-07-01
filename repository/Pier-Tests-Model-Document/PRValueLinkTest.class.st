Class {
	#name : #PRValueLinkTest,
	#superclass : #PRLinkTest,
	#category : #'Pier-Tests-Model-Document'
}

{ #category : #testing }
PRValueLinkTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRValueLinkTest >> actualClass [
	^ PRValueLink
]

{ #category : #private }
PRValueLinkTest >> referenceString [
	^ 'value:structure'
]

{ #category : #tests }
PRValueLinkTest >> testBroken [
	self assert: self instance isBroken.
	
	self instance reference: 'value:does-not-exist'.
	self assert: self instance isBroken.
	
	self instance reference: 'value:STRUCTURE'.
	self deny: self instance isBroken.
	
	self instance reference: 'value:structure'.
	self deny: self instance isBroken.
	
	self instance reference: 'value:  structure'.
	self deny: self instance isBroken.
	
	self instance reference: 'value:structure  '.
	self deny: self instance isBroken
]

{ #category : #'tests-utilities' }
PRValueLinkTest >> testFilterReject [
	self instance parameterAt: 'reject' put: 'Page'.
	self assert: (self instance selectAndReject: PRPage new) isNil.
	self assert: (self instance selectAndReject: PRFile new) notNil.	
]

{ #category : #'tests-utilities' }
PRValueLinkTest >> testFilterSelect [
	self instance parameterAt: 'select' put: 'Page'.
	self assert: (self instance selectAndReject: PRPage new) notNil.
	self assert: (self instance selectAndReject: PRFile new) isNil
]

{ #category : #'tests-utilities' }
PRValueLinkTest >> testFormatStructure [
	| structure context document |
	structure := PRPage named: 'foo'.
	context := PRContext kernel: PRKernel basicNew structure: structure.

	self instance reference: 'value:structure'.
	document := self instance formatStructure: structure in: context.
	self assert: document text = 'Foo'.

	self instance parameterAt: 'display' put: 'name'.
	document := self instance formatStructure: structure in: context.
	self assert: document text = 'foo'.
	
	self instance parameterAt: 'display' put: '{name}'.
	document := self instance formatStructure: structure in: context.
	self assert: document text = 'foo'.
	
	self instance parameterAt: 'display' put: '{name} and {title}'.
	document := self instance formatStructure: structure in: context.
	self assert: document text = 'foo and Foo'.

	self instance parameterAt: 'link' put: nil.
	document := self instance formatStructure: structure in: context.
	self assert: document target = structure.
	self assert: document children first text = 'foo and Foo'
]

{ #category : #'tests-utilities' }
PRValueLinkTest >> testLookupStructure [
	| structure1 structure2 structure3 |
	structure1 := PRPage named: '1'.
	structure2 := PRPage named: '2'.
	structure3 := PRPage named: '3'.

	structure1 addChild: structure2.
	structure2 addChild: structure3.
	
	self instance reference: 'value:structure'.

	self instance parameterAt: 'level' put: '-3'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '-2'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure1.
	
	self instance parameterAt: 'level' put: '-1'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure2.
	
	self instance parameterAt: 'level' put: '0'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure3.
	
	self instance parameterAt: 'level' put: '1'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure1.
	
	self instance parameterAt: 'level' put: '2'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure2.
	
	self instance parameterAt: 'level' put: '3'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure3.
	
	self instance parameterAt: 'level' put: '4'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil
]

{ #category : #'tests-utilities' }
PRValueLinkTest >> testLookupStructureLower [
	| structure1 structure2 structure3 |
	structure1 := PRPage named: '1'.
	structure2 := PRPage named: '2'.
	structure3 := PRPage named: '3'.

	structure1 addChild: structure2.
	structure2 addChild: structure3.
	
	self instance reference: 'value:structure'.
	self instance parameterAt: 'lower' put: '2'.

	self instance parameterAt: 'level' put: '-3'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '-2'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '-1'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure2.
	
	self instance parameterAt: 'level' put: '0'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure3.
	
	self instance parameterAt: 'level' put: '1'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '2'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure2.
	
	self instance parameterAt: 'level' put: '3'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure3.
	
	self instance parameterAt: 'level' put: '4'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil
]

{ #category : #'tests-utilities' }
PRValueLinkTest >> testLookupStructureUpper [
	| structure1 structure2 structure3 |
	structure1 := PRPage named: '1'.
	structure2 := PRPage named: '2'.
	structure3 := PRPage named: '3'.

	structure1 addChild: structure2.
	structure2 addChild: structure3.
	
	self instance reference: 'value:structure'.
	self instance parameterAt: 'upper' put: '2'.

	self instance parameterAt: 'level' put: '-3'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '-2'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure1.
	
	self instance parameterAt: 'level' put: '-1'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure2.
	
	self instance parameterAt: 'level' put: '0'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '1'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure1.
	
	self instance parameterAt: 'level' put: '2'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure2.
	
	self instance parameterAt: 'level' put: '3'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '4'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil
]

{ #category : #'tests-utilities' }
PRValueLinkTest >> testSelectAndReject [
	| structure1 structure2 structure3 |
	structure1 := PRPage named: '1'.
	structure2 := PRPage named: '2'.
	structure3 := PRPage named: '3'.

	structure1 addChild: structure2.
	structure2 addChild: structure3.
	
	self instance reference: 'value:structure'.
	self instance parameterAt: 'lower' put: '2'.

	self instance parameterAt: 'level' put: '-3'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '-2'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '-1'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure2.
	
	self instance parameterAt: 'level' put: '0'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure3.
	
	self instance parameterAt: 'level' put: '1'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil.
	
	self instance parameterAt: 'level' put: '2'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure2.
	
	self instance parameterAt: 'level' put: '3'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) = structure3.
	
	self instance parameterAt: 'level' put: '4'.
	self assert: (self instance lookupStructure: structure3 do: [ :structure | structure ]) isNil
]

{ #category : #tests }
PRValueLinkTest >> testSelectorFor [
	self assert: (self instance selectorFor: 'date') = #dateIn:.
	self assert: (self instance selectorFor: 'context') = #contextIn:
]

{ #category : #tests }
PRValueLinkTest >> testSmoke [
	| context kernel |
	kernel := PRKernel new
		name: 'test';
		root: (PRPage named: 'root');
		yourself.
	context := PRContext kernel: kernel.
	self instance pragmas
		do: [ :pragma | 
			self instance reference: 'value:' , pragma arguments first.
			self assert: self instance title = pragma arguments first.
			"Should work without throwing an error"
			self instance valueIn: context ]
]

{ #category : #tests }
PRValueLinkTest >> testTitle [
	self instance reference: 'value:structure'.
	self assert: self instance title = 'structure'
]
