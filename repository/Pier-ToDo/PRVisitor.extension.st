Extension { #name : #PRVisitor }

{ #category : #'*Pier-ToDo' }
PRVisitor >> visitToDo: anObject [
	self visitCase: anObject
]

{ #category : #'*Pier-ToDo' }
PRVisitor >> visitToDoItem: anObject [
	self visitPage: anObject
]
