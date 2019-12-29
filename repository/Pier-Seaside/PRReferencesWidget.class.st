Class {
	#name : #PRReferencesWidget,
	#superclass : #PRStructuresWidget,
	#category : #'Pier-Seaside-Widgets'
}

{ #category : #'accessing-defaults' }
PRReferencesWidget class >> defaultMaxItems [
	^ 10
]

{ #category : #testing }
PRReferencesWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PRReferencesWidget class >> label [
	^ 'References'
]

{ #category : #accessing }
PRReferencesWidget >> unfilteredItems [
	^ ((self context root incomingReferences
		to: self context structure;
		collect: [ :each | each owner ])
		select: [ :each | each notNil ])
			asSet
]
