Class {
	#name : #PREditFileCommandTest,
	#superclass : #PREditCommandTest,
	#category : #'Pier-Tests-Model-Command'
}

{ #category : #testing }
PREditFileCommandTest class >> isAbstract [
	^ false
]

{ #category : #private }
PREditFileCommandTest >> structureInstance [
	^ PRFile named: 'command'
]

{ #category : #'tests-file' }
PREditFileCommandTest >> testFileChanged [
	| file |
	self command
		write: (file := MAFileModel new
			contents: 'foobar';
			filename: 'test.txt';
			mimetype: 'text/plain';
			yourself)
		using: PRFile new descriptionFile.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure file = file
]

{ #category : #'tests-file' }
PREditFileCommandTest >> testFileInitialized [
	self assert: (self command readUsing: PRFile new descriptionFile) = self structure file
]

{ #category : #'tests-file' }
PREditFileCommandTest >> testFileUnchanged [
	| file |
	file := self structure file.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure file = file
]
