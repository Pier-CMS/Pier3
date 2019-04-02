Class {
	#name : #PUUsersWidget,
	#superclass : #PUMemberWidget,
	#category : #'Pier-Security-Widgets'
}

{ #category : #testing }
PUUsersWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PUUsersWidget class >> label [
	^ 'Users'
]

{ #category : #accessing }
PUUsersWidget >> memberClass [
	^ PUUser
]

{ #category : #accessing }
PUUsersWidget >> members [
	^ self context kernel users
]

{ #category : #actions }
PUUsersWidget >> remove: aMember [
	self context user = aMember ifTrue: [ 
		^ self show: (WAFormDialog new
			addMessage: 'You cannot remove yourself.';
			yourself) ].
	self remove: aMember do: [ :member | member groups: #() ]
]
