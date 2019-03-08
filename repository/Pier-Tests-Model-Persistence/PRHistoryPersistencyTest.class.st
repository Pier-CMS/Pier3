Class {
	#name : #PRHistoryPersistencyTest,
	#superclass : #PRPersistencyTest,
	#category : #'Pier-Tests-Model-Persistence'
}

{ #category : #testing }
PRHistoryPersistencyTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRHistoryPersistencyTest >> actualClass [
	^ PRHistoryPersistency
]

{ #category : #tests }
PRHistoryPersistencyTest >> testHistory [
	| command |
	command := self editTitle: 'Foo'.
	self assert: self persistency history isEmpty.
	self persistency execute: command.
	self assert: self persistency history size = 1.
	self deny: self persistency history first = command context.
	self assert: self persistency history first structure = command context structure
]

{ #category : #tests }
PRHistoryPersistencyTest >> testMaxHistory [
	| command |
	self persistency maxHistory: 5.
	10 timesRepeat: [ 
		self persistency 
			execute: (command := self editTitle: 'Foo').
		self assert: self persistency history size <= 5 ].
	self assert: self persistency history size = 5
]

{ #category : #tests }
PRHistoryPersistencyTest >> testReplacement [
	| command1 command2 |
	self persistency
		execute: (command1 := self editTitle: '1');
		execute: (command2 := self editTitle: '2').
	self assert: self persistency history size = 2.
	self deny: self persistency history first command = command1.
	self assert: self persistency history first command class = command1 class.
	self deny: self persistency history second command = command2.
	self assert: self persistency history second command class = command2 class.
	
	self kernel persistency: self persistencyInstance.
	self assert: self persistency history size = 2.
	self deny: self persistency history first command = command1.
	self assert: self persistency history first command class = command1 class.
	self deny: self persistency history second command = command2.
	self assert: self persistency history second command class = command2 class.
	
	self kernel persistency: nil.
	self assert: self persistency history isEmpty.
	
	self kernel persistency: self persistencyInstance.
	self assert: self persistency history isEmpty
]
