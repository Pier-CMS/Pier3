Class {
	#name : #PUSecurityWidget,
	#superclass : #PRWidget,
	#category : #'Pier-Security-Widgets'
}

{ #category : #accessing }
PUSecurityWidget class >> groupLabel [
	^ 'Pier System'
]

{ #category : #testing }
PUSecurityWidget class >> isAbstract [
	^ false
]

{ #category : #accessing }
PUSecurityWidget class >> label [
	^ 'Credentials'
]

{ #category : #rendering }
PUSecurityWidget >> renderContentOn: html [
	| user |
	user := self context user.
	user isNil ifTrue: [ ^ self ].
	html span 
		class: 'changePassword'; 
		with: [
			html anchor
				goto: (self context command: PUEditUser new); 
				with: 'change password' ]
]
