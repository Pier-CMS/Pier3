Class {
	#name : #ConfigurationForPillar,
	#superclass : #Object,
	#category : #'Pier-Model-Utilities'
}

{ #category : #accessing }
ConfigurationForPillar >> newLine [
	^ Smalltalk os lineEnding
]
