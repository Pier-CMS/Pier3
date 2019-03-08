"
Command (so called) to view a structure.
"
Class {
	#name : #PRViewCommand,
	#superclass : #PRCommand,
	#category : #'Pier-Model-Command'
}

{ #category : #accessing }
PRViewCommand class >> accessKey [
	^ $v
]

{ #category : #testing }
PRViewCommand class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRViewCommand class >> label [
	^ 'View'
]

{ #category : #testing }
PRViewCommand >> isLogged [
	^ false
]

{ #category : #testing }
PRViewCommand >> isView [
	^ true
]
