Class {
	#name : #PUGroupsWidget,
	#superclass : #PUMemberWidget,
	#category : #'Pier-Security-Widgets'
}

{ #category : #testing }
PUGroupsWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PUGroupsWidget class >> label [
	^ 'Groups'
]

{ #category : #accessing }
PUGroupsWidget >> memberClass [
	^ PUGroup
]

{ #category : #accessing }
PUGroupsWidget >> members [
	^ self context kernel groups
]

{ #category : #actions }
PUGroupsWidget >> remove: aMember [
	aMember users isEmpty ifFalse: [ 
		^ self show: (WAFormDialog new
			addMessage: 'Remove all users before removing a group.';
			yourself) ].
	super remove: aMember
]
