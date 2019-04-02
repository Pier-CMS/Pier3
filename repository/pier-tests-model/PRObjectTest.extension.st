Extension { #name : #PRObjectTest }

{ #category : #'*pier-tests-model' }
PRObjectTest class >> buildTestClassFor: aClass [ 
	" self buildTestClassFor: PRObject "
	| thisName thisClass thisCategory parentClass |
	thisName := (aClass name , 'Test') asSymbol.
	(thisName beginsWith: 'PR') ifFalse: [ ^ self ].
	thisClass := GRPlatform current magritteClassNamed: thisName.
	thisCategory := 'Pier-Tests-' , (aClass category copyAfterLast: $-).
	parentClass := self = thisClass 
		ifTrue: [ self superclass ]
		ifFalse: 
			[ GRPlatform current magritteClassNamed: (aClass superclass name , 'Test') asSymbol ].
	thisClass := parentClass 
		subclass: thisName
		instanceVariableNames: (thisClass isNil 
				ifFalse: [ thisClass instanceVariablesString ]
				ifTrue: [ String new ])
		classVariableNames: ''
		poolDictionaries: ''
		category: thisCategory.
	thisClass 
		compile: 'actualClass
	^ ' , aClass name
		classified: #private.
	thisClass class 
		compile: 'isAbstract
	^ ' , aClass isAbstract greaseString
		classified: #testing.
	aClass subclassesDo: [ :each | self buildTestClassFor: each ]
]

{ #category : #'*pier-tests-model' }
PRObjectTest >> contextInstance [
	^ PRContext kernel: self kernelInstance
]

{ #category : #'*pier-tests-model' }
PRObjectTest >> kernelInstance [
	^ PRKernel new
		name: 'test';
		root: self rootInstance;
		persistency: self persistencyInstance;
		yourself
]

{ #category : #'*pier-tests-model' }
PRObjectTest >> persistencyInstance [
	^ PRNullPersistency new
]

{ #category : #'*pier-tests-model' }
PRObjectTest >> rootInstance [
	^ (PRPage named: 'root')
		addChild: ((PRPage named: 'folder')
			addChild: (PRPage named: 'child');
			addChild: (self structureInstance);
			yourself);
		yourself
]

{ #category : #'*pier-tests-model' }
PRObjectTest >> structureInstance [
	^ PRPage named: 'structure'
]
