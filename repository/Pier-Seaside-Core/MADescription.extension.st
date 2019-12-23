Extension { #name : #MADescription }

{ #category : #'*pier-seaside' }
MADescription >> beSetting [
	self propertyAt: #setting put: true
]

{ #category : #'*pier-seaside' }
MADescription >> isSetting [
	^ self propertyAt: #setting ifAbsent: [ false ]
]
