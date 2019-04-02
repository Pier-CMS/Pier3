Class {
	#name : #PUChangeUser,
	#superclass : #PRCommand,
	#category : #'Pier-Security-Command'
}

{ #category : #accessing }
PUChangeUser class >> accessKey [
	^ $l
]

{ #category : #accessing }
PUChangeUser class >> permissions [
	^ #()
]

{ #category : #events }
PUChangeUser >> doValidate [
	"Change user commands do not require validation."
]

{ #category : #testing }
PUChangeUser >> isLogged [
	^ false
]
