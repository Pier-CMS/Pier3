Class {
	#name : #PRContextFilter,
	#superclass : #WARequestFilter,
	#instVars : [
		'presenter'
	],
	#category : #'Pier-Seaside-Core'
}

{ #category : #'instance creation' }
PRContextFilter class >> on: aPierFrame [
	^ self basicNew initializeOn: aPierFrame
]

{ #category : #processing }
PRContextFilter >> handleFiltered: aRequestContext [
	^ PRCurrentContextHolder use: presenter during: [ super handleFiltered: aRequestContext ]
]

{ #category : #initialization }
PRContextFilter >> initializeOn: aPierFrame [
	self initialize.
	presenter := aPierFrame
]
