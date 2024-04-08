Extension { #name : #PRAddCommand }

{ #category : #'*pier-security-private' }
PRAddCommand >> descriptionTypeSecurity: aDescription [
	"Only list the structures with that the current user can actually add."

	<magritteDescription: #descriptionType>
	^ aDescription
		  options: (self structureClassesSecurity collect: [ :e | e name ]);
		  yourself
]

{ #category : #'*pier-security' }
PRAddCommand >> permission [

	^ PUAddPermission on: self class structure: self typeClass
]

{ #category : #'*pier-security' }
PRAddCommand class >> permissions [
	^ PRStructure withAllConcreteClasses
		collect: [ :class | PUAddPermission on: self structure: class ]
]

{ #category : #'*pier-security-private' }
PRAddCommand >> structureClassesSecurity [
	| theContext |
	theContext := self context.
	^ self structureClasses select: [ :class |
		theContext structure securityDecoration
			hasPermission: (PUAddPermission
				on: self class structure: class)
			for: theContext user ]
]
