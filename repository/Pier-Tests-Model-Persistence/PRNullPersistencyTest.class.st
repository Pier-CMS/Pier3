Class {
	#name : #PRNullPersistencyTest,
	#superclass : #PRPersistencyTest,
	#category : #'Pier-Tests-Model-Persistence'
}

{ #category : #testing }
PRNullPersistencyTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRNullPersistencyTest >> actualClass [
	^ PRNullPersistency
]
