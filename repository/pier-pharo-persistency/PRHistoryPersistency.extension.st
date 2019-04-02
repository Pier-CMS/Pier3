Extension { #name : #PRHistoryPersistency }

{ #category : #'*pier-pharo-persistency' }
PRHistoryPersistency >> sanitize [
	super sanitize.
	history := OrderedCollection new
]
