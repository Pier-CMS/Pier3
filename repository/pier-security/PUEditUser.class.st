Class {
	#name : #PUEditUser,
	#superclass : #PRChangeCommand,
	#category : #'Pier-Security-Command'
}

{ #category : #testing }
PUEditUser class >> isAbstract [
	^ false
]

{ #category : #testing }
PUEditUser class >> isValidIn: aContext [
	^ aContext isLoggedIn
]

{ #category : #accessing }
PUEditUser class >> label [
	^ 'Edit User'
]

{ #category : #accessing }
PUEditUser class >> permissions [
	^ #()
]

{ #category : #events }
PUEditUser >> doValidate [
	"Change user commands do not require validation."
]

{ #category : #testing }
PUEditUser >> magritteDescription [
	^ self context user magritteDescription
		select: [ :each | each hasProperty: #public ]

]

{ #category : #accessing }
PUEditUser >> target [
	^ self context user
]
