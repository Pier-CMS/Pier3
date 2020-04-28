Extension { #name : #PRViewCommand }

{ #category : #'*Pier-ToDo' }
PRViewCommand >> shouldBeIncludedInCompleteHistory [
	^ self viewComponentClass isNotNil
				and: [ self viewComponentClass = PRChangesView ]
]
