Class {
	#name : #PRLogView,
	#superclass : #PRHistoryView,
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRLogView class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRLogView class >> label [
	^ 'Log'
]
