Class {
	#name : #PRImagePersistencyTest,
	#superclass : #PRPersistencyTest,
	#category : #'Pier-Tests-Pharo-Persistency'
}

{ #category : #testing }
PRImagePersistencyTest class >> isAbstract [
	^ false
]

{ #category : #private }
PRImagePersistencyTest >> actualClass [
	^ PRImagePersistency
]
