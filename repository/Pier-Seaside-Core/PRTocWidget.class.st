Class {
	#name : #PRTocWidget,
	#superclass : #PRWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #testing }
PRTocWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRTocWidget class >> label [
	^ 'Table of Contents'
]

{ #category : #rendering }
PRTocWidget >> renderContentOn: html [
	PRTocRenderer new
		start: self context structure
		in: self on: html
]
