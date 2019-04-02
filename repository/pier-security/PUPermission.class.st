Class {
	#name : #PUPermission,
	#superclass : #PRObject,
	#instVars : [
		'command'
	],
	#category : #'Pier-Security-Model'
}

{ #category : #testing }
PUPermission class >> isAbstract [
	^ false
]

{ #category : #'instance creation' }
PUPermission class >> on: aClass [
	^ self new
		setCommand: aClass;
		yourself
]

{ #category : #comparing }
PUPermission >> = aPermission [
	^ self species = aPermission species
		and: [ self command = aPermission command ]
]

{ #category : #accessing }
PUPermission >> command [
	"Answer the command class this permission applies to."

	^ command
]

{ #category : #'accessing-description' }
PUPermission >> descriptionLabel [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #label;
		yourself
]

{ #category : #comparing }
PUPermission >> hash [
	^ self command hash
]

{ #category : #accessing }
PUPermission >> label [
	"Answer the label this command class is refered to in the user interface."

	^ self command label
]

{ #category : #printing }
PUPermission >> printOn: aStream [
	aStream nextPutAll: self label
]

{ #category : #initialization }
PUPermission >> setCommand: aClass [
	command := aClass
]

{ #category : #testing }
PUPermission >> validCommand: aCommand [
	^ self command = aCommand species
]
