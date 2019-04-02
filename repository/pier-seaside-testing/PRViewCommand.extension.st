Extension { #name : #PRViewCommand }

{ #category : #'*pier-seaside-testing' }
PRViewCommand >> isRestful [
	^ self viewComponentClass isRestful
]
