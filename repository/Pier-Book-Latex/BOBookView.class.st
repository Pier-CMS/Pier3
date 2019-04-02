Class {
	#name : #BOBookView,
	#superclass : #PRRawView,
	#instVars : [
		'book'
	],
	#category : #'Pier-Book-Latex'
}

{ #category : #testing }
BOBookView class >> isAbstract [
	^ self name = #BOBookView
]

{ #category : #testing }
BOBookView class >> isValidIn: aContext [
	^ (super isValidIn: aContext) and: [ aContext structure isPublication ]
]

{ #category : #accessing }
BOBookView >> book [
	^ book ifNil: [ book := self findBook ]
]

{ #category : #private }
BOBookView >> findBook [
	^ self context structure findAncestor: [ :each | each isPublication and: [ each isBook ] ]
]

{ #category : #accessing }
BOBookView >> writer [
	^ BOLatexWriter
]
