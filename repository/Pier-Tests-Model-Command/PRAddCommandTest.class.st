Class {
	#name : #PRAddCommandTest,
	#superclass : #PRCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PRAddCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRAddCommandTest >> actualClass [
	^ PRAddCommand
]

{ #category : #tests }
PRAddCommandTest >> testAddChild [
	| child |
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: (self structure childrenDecoration
		includes: self command name).

	child := self structure childrenDecoration
		at: self command name.
	self assert: child name = self command name.
	self assert: child species = self command type
]

{ #category : #tests }
PRAddCommandTest >> testAddConflict [
	self
		shouldnt: [ self command execute ]
		raise: PRConflictingNameError.
	self
		should: [ self command execute ]
		raise: PRConflictingNameError
]

{ #category : #'tests-accessing' }
PRAddCommandTest >> testLink [
	| link |
	self assert: self command link isNil.
	
	link := PRInternalLink new.
	link owner: self command structure.
	self command link: link.
	self assert: self command link = link.
	self assert: link isBroken.
	
	self command execute.
	self deny: link isBroken.
	self assert: link target name = self command name.
	self assert: link reference = 'untitled'
]

{ #category : #'tests-accessing' }
PRAddCommandTest >> testName [
	self assert: self command name = 'untitled'.
	self command name: 'something'.
	self assert: self command name = 'something'
]

{ #category : #'tests-utilties' }
PRAddCommandTest >> testSuggestName [
	command := self command
		suggestName: 'sucker for your sound'.
	self assert: self command name = 'sucker-for-your-sound'.
	self assert: self command title = 'Sucker for your sound'.
	
	command := self command
		suggestName: 'Gameboy&Homeboy'.
	self assert: self command name = 'gameboy_homeboy'.
	self assert: self command title = 'Gameboy&Homeboy'
]

{ #category : #'tests-accessing' }
PRAddCommandTest >> testType [
	self assert: self command type = PRPage.
	self command type: PRFile.
	self assert: self command type = PRFile
]

{ #category : #'tests-utilties' }
PRAddCommandTest >> testTypeClasses [
	| classes addCommmandInstance |

	addCommmandInstance := self actualInstance setContext: self.
	 classes := addCommmandInstance structureClasses.
	self assert: (classes notEmpty).
	self assert: (classes includes: PRPage)
]

{ #category : #tests }
PRAddCommandTest >> testUncheckedConflict [
	self command execute.	
	self command beUnchecked.
	self command structure enumerator
		do: [ :each | each remove ].	
	self
		shouldnt: [ self command execute ]
		raise: PRConflictingNameError
]

{ #category : #'tests-utilties' }
PRAddCommandTest >> testUniqueTitle [
	20 timesRepeat: [
		self
			shouldnt: [
				self structure addChild: (PRPage named: (self command
					uniqueName: 'foo' in: self structure)) ]
			raise: PRConflictingNameError ].
	#( 'foo' 'foo-2' 'foo-9' 'foo-10' 'foo-11' 'foo-20' ) do: [ :each |
		self assert: (self structure childrenDecoration includes: each) ]
]
