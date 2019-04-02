Class {
	#name : #PUAddPermission,
	#superclass : #PUPermission,
	#instVars : [
		'structure'
	],
	#category : #'Pier-Security-Model'
}

{ #category : #'instance creation' }
PUAddPermission class >> on: aCommand structure: aClass [ 
	^ (self on: aCommand) setStructure: aClass
]

{ #category : #comparing }
PUAddPermission >> = anObject [
	^ super = anObject
		and: [ self structure = anObject structure ]
]

{ #category : #comparing }
PUAddPermission >> hash [
	^ super hash bitXor: self structure hash
]

{ #category : #accessing }
PUAddPermission >> label [
	^ super label , ' ' , self structure label
]

{ #category : #initialization }
PUAddPermission >> setStructure: aClass [
	structure := aClass
]

{ #category : #accessing }
PUAddPermission >> structure [
	^ structure
]
