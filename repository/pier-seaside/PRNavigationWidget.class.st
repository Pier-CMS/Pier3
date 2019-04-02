Class {
	#name : #PRNavigationWidget,
	#superclass : #PRStructuresWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #testing }
PRNavigationWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRNavigationWidget class >> label [
	^ 'Navigation'
]

{ #category : #rendering }
PRNavigationWidget >> renderContentOn: html [
	self renderParents: self context structure parents on: html
]

{ #category : #rendering }
PRNavigationWidget >> renderParents: aCollection on: html [
	html unorderedList: [
		html listItem: [
			self renderItem: aCollection first on: html.
			(aCollection size = 1 or: [ aCollection size = 2 and: [ (self childrenOf: aCollection last) isEmpty ] ])
				ifTrue: [ self renderItems: (self childrenOf: aCollection first) on: html ]
				ifFalse: [ self renderParents: aCollection allButFirst on: html ] ] ]
]
