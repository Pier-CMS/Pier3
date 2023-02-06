"
This class was created for a specific problem in Pharo 9:
1. WebBrowser openOn: 'http://localhost:8080/pier'
2. Login
3. Click Settings
4. Click Save
5. The problem is: Page: Input is conflicting with concurrent modification
"
Class {
	#name : #PRSettingCommandTest,
	#superclass : #PREditCommandTest,
	#category : #'pier-tests-seaside-model'
}

{ #category : #testing }
PRSettingCommandTest class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRSettingCommandTest >> actualClass [
	^ PRSettingsCommand
]

{ #category : #private }
PRSettingCommandTest >> structureInstance [
	^ PRPage named: 'command'
]

{ #category : #accessing }
PRSettingCommandTest >> testHide [
	| settings |
	settings := PRPage new settingsDescription.
	settings beHidden.
	self command
		write: settings
		using: PRPage new descriptionEnvironment.
	self
		shouldnt: [ self command execute ]
		raise: PRStructureError.
	self assert: self structure settingsDescription = settings
]
