Extension { #name : #MADescription }

{ #category : #'*Pier-Seaside' }
MADescription >> beSetting [
	self propertyAt: #setting put: true
]

{ #category : #'*Pier-Seaside' }
MADescription >> isSetting [
	^ self propertyAt: #setting ifAbsent: [ false ]
]
