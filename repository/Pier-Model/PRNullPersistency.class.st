"
The simplest possible persistency strategy. Using this strategy means there is no persistency (except for manual image saving). Also no history of applied commands is remembered.
"
Class {
	#name : #PRNullPersistency,
	#superclass : #PRPersistency,
	#category : #'Pier-Model-Persistence'
}

{ #category : #enumerating }
PRNullPersistency >> do: aBlock [
	"There is no history for now."
]
