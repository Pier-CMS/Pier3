Class {
	#name : #BOIndexLink,
	#superclass : #PRLink,
	#category : #'Pier-Book-Utilities'
}

{ #category : #testing }
BOIndexLink class >> isAbstract [
	^ false
]

{ #category : #testing }
BOIndexLink class >> isValidReference: aString [
	^ aString beginsWithSubCollection: 'index:'
]

{ #category : #visiting }
BOIndexLink >> accept: aVisitor [
	aVisitor visitIndexLink: self
]

{ #category : #accessing }
BOIndexLink >> entries [
	^ self title subStrings: '!'
]

{ #category : #accessing }
BOIndexLink >> title [
	^ super title copyAfter: $:
]
