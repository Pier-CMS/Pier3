Class {
	#name : #PRCommandTest,
	#superclass : #PRObjectTest,
	#instVars : [
		'kernel',
		'structure',
		'context',
		'command'
	],
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PRCommandTest class >> isAbstract [
	^ true
]

{ #category : #private }
PRCommandTest >> actualClass [
	^ PRCommand
]

{ #category : #private }
PRCommandTest >> actualInstance [
	^ self actualClass new
]

{ #category : #accessing }
PRCommandTest >> command [
	^ command ifNil: [ command := self actualInstance ]
]

{ #category : #accessing }
PRCommandTest >> context [
	^ context ifNil: [ context := self contextInstance ]
]

{ #category : #private }
PRCommandTest >> contextInstance [
	^ PRContext kernel: self kernel structure: self structure command: self command
]

{ #category : #accessing }
PRCommandTest >> instance [
	^ self command
]

{ #category : #accessing }
PRCommandTest >> kernel [
	^ kernel ifNil: [ kernel := self kernelInstance ]
]

{ #category : #private }
PRCommandTest >> kernelInstance [
	^ PRKernel new
		root: ((PRPage named: 'root')
			addChild: (PRPage named: 'folder');
			addChild: (self structure);
			yourself);
		yourself
]

{ #category : #running }
PRCommandTest >> setUp [
	context := self contextInstance
]

{ #category : #accessing }
PRCommandTest >> structure [
	^ structure ifNil: [ structure := self structureInstance ]
]

{ #category : #private }
PRCommandTest >> structureInstance [
	^ PRPage named: 'command'
]

{ #category : #'tests-accessing' }
PRCommandTest >> testAccessKey [
	self assert: (self actualClass accessKey isNil or: [ self actualClass accessKey isCharacter ])
]

{ #category : #'tests-answering' }
PRCommandTest >> testCancelAnswer [
	self assert: self command cancelAnswer notNil.
	self command cancelAnswer: self context.
	self deny: self command cancelAnswer = self context
]

{ #category : #'tests-accessing' }
PRCommandTest >> testContext [
	self assert: self command context notNil.
	context := self context command: self command.
	self assert: self command context = self context
]

{ #category : #'tests-accessing' }
PRCommandTest >> testDate [
	| stamp |
	self assert: self command date isNil.
	self command timestamp: (stamp := GRPlatform current magritteTimeStampClass now).
	self assert: self command date = stamp asDate
]

{ #category : #'tests-testing' }
PRCommandTest >> testIsChecked [
	self assert: self command isChecked.

	self command beUnchecked.
	self deny: self command isChecked.

	self command beChecked.
	self assert: self command isChecked
]

{ #category : #'tests-testing' }
PRCommandTest >> testIsEdit [
	self deny: self command isEdit
]

{ #category : #'tests-testing' }
PRCommandTest >> testIsLogged [
	self assert: self command isLogged
]

{ #category : #'tests-testing' }
PRCommandTest >> testIsQuick [
	self deny: self command isQuick
]

{ #category : #'tests-testing' }
PRCommandTest >> testIsView [
	self deny: self command isView
]

{ #category : #'tests-accessing' }
PRCommandTest >> testKernel [
	self assert: self command kernel = self kernel
]

{ #category : #'tests-accessing' }
PRCommandTest >> testLabel [
	self assert: self actualClass label isString.
	self assert: self actualClass label isEmpty not.
	
	self assert: self instance label isString.
	self assert: self instance label isEmpty not
]

{ #category : #'tests-accessing' }
PRCommandTest >> testRoot [
	self assert: self command root = self kernel root
]

{ #category : #'tests-accessing' }
PRCommandTest >> testShortLabel [
	self assert: self actualClass shortLabel isString.
	self assert: self actualClass shortLabel isEmpty not
]

{ #category : #'tests-accessing' }
PRCommandTest >> testStructure [
	self assert: self command structure = self structure
]

{ #category : #'tests-answering' }
PRCommandTest >> testSuccessAnswer [
	self assert: self command successAnswer notNil.
	self command successAnswer: self context.
	self deny: self command successAnswer = self context
]

{ #category : #'tests-accessing' }
PRCommandTest >> testTime [
	| stamp |
	self assert: self command time isNil.
	self command timestamp: (stamp := GRPlatform current magritteTimeStampClass now).
	self assert: self command time = stamp asTime
]

{ #category : #'tests-accessing' }
PRCommandTest >> testTimestamp [
	| stamp |
	self assert: self command timestamp isNil.
	self command timestamp: (stamp := GRPlatform current magritteTimeStampClass now).
	self assert: self command timestamp = stamp
]

{ #category : #'tests-utilities' }
PRCommandTest >> testUniqueName [
	20 timesRepeat: [
		self
			shouldnt: [
				self structure addChild: (PRPage named: (self command
					uniqueName: 'foo' in: self structure)) ]
			raise: PRConflictingNameError ]
]

{ #category : #'tests-utilities' }
PRCommandTest >> testUniqueNameDoesNotAddDecoration [
	self command uniqueName: 'foo' in: self structure.
	self structure
		decorationOfClass: self structure childrenDecorationClass
		ifAbsent: [ ^ self ].
	self assert: self structure hasChildren
]

{ #category : #'tests-validating' }
PRCommandTest >> testValidateChild [
	PRCurrentContextHolder
		use: self
		during: [ 
			self
				should: [
					self command
						validateChild: (PRPage named: 'folder')
						in: self context root ]
				raise: PRConflictingNameError.
			self
				shouldnt: [
					self command
						validateChild: (PRPage named: 'zork')
						in: self context root ]
				raise: PRConflictingNameError.
			self
				shouldnt: [
					self command
						validateChild: (self context root childrenDecoration at: 'folder')
						in: self context root ]
				raise: PRConflictingNameError ]
]

{ #category : #'tests-validating' }
PRCommandTest >> testValidateChildDoesNotAddDecoration [
	self command
		validateChild: (PRPage named: 'zork')
		in: self context root.
	self structure
		decorationOfClass: self structure childrenDecoration
		ifAbsent: [ ^ self ].
	self assert: self structure hasChildren
]

{ #category : #'tests-validating' }
PRCommandTest >> testValidateChildNamed [
	PRCurrentContextHolder
		use: self
		during: [ 
			self
				should: [
					self command
						validateChild: PRPage new
						named: 'folder'
						in: self context root ]
				raise: PRConflictingNameError.
			self
				shouldnt: [
					self command
						validateChild: PRPage new
						named: 'zork'
						in: self context root ]
				raise: PRConflictingNameError.
			self
				shouldnt: [
					self command
						validateChild: (self context root childrenDecoration
							at: 'folder')
						named: 'zork'
						in: self context root ]
				raise: PRConflictingNameError ]
]

{ #category : #'tests-validating' }
PRCommandTest >> testValidateName [
	PRCurrentContextHolder
		use: self
		during: [ 
			self
				shouldnt: [
					self command
						validateName: 'zork'
						of: PRPage new
						in: self context root ]
				raise: PRConflictingNameError.
			self
				should: [
					self command
						validateName: 'folder'
						of: PRPage new
						in: self context root ]
				raise: PRConflictingNameError.
			self
				shouldnt: [
					self command
						validateName: 'zork'
						of: (self context root childrenDecoration at: 'folder')
						in: self context root ]
				raise: PRConflictingNameError.
			self
				shouldnt: [
					self command
						validateName: 'folder'
						of: (self context root childrenDecoration at: 'folder')
						in: self context root ]
				raise: PRConflictingNameError ]
]

{ #category : #'tests-validating' }
PRCommandTest >> testValidateNesting [
	self
		shouldnt: [
			self command
				validateNestingOf: self context root
				in: PRPage new ]
		raise: PRInvalidNestingError.
	self
		shouldnt: [
			self command
				validateNestingOf: PRPage new
				in: self context root ]
		raise: PRInvalidNestingError
]
