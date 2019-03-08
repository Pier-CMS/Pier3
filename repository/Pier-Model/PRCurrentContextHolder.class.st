Class {
	#name : #PRCurrentContextHolder,
	#superclass : #GRNotification,
	#category : #'Pier-Model-Kernel'
}

{ #category : #utilities }
PRCurrentContextHolder class >> use: anObject during: aBlock [
	^ aBlock on: self do: [ :notification | notification resume: anObject ]
]

{ #category : #accessing }
PRCurrentContextHolder class >> value [
	^ self signal
]
