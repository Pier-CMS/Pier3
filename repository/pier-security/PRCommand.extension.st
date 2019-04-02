Extension { #name : #PRCommand }

{ #category : #'*pier-security' }
PRCommand >> permission [
	"The permission required to make the receiver executable in the setup context. ==nil== if no permission is required."

	| permissions |
	permissions := self class permissions.
	^ permissions isEmpty ifFalse: [ permissions anyOne ]
]

{ #category : #'*pier-security' }
PRCommand class >> permissions [
	"Answer a collection of permissions as defined by the receiver."

	^ Array with: (PUPermission on: self)
]
