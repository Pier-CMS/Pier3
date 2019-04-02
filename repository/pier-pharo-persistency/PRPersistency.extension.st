Extension { #name : #PRPersistency }

{ #category : #'*pier-pharo-persistency' }
PRPersistency >> desanitize [
	"Sanitizes the receiver to be serializeable."
	
	mutex := self defaultMutex
]

{ #category : #'*pier-pharo-persistency' }
PRPersistency >> sanitize [
	"Sanitizes the receiver to be serializeable."
	
	mutex := nil
]
