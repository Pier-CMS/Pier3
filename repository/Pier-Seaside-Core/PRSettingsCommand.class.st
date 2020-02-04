"
Command to edit settings of a structure. This command collects all the descriptions tagged as ==#beSetting==.
"
Class {
	#name : #PRSettingsCommand,
	#superclass : #PRChangeCommand,
	#category : #'Pier-Seaside-Model'
}

{ #category : #accessing }
PRSettingsCommand class >> accessKey [
	^ $t
]

{ #category : #testing }
PRSettingsCommand class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRSettingsCommand class >> label [
	^ 'Settings'
]

{ #category : #accessing }
PRSettingsCommand >> magritteDescription [
	^ self structure settingsDescription
]
