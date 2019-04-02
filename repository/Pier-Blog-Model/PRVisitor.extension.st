Extension { #name : #PRVisitor }

{ #category : #'*pier-blog-model' }
PRVisitor >> visitBlog: anObject [
	self visitCase: anObject
]

{ #category : #'*pier-blog-model' }
PRVisitor >> visitComment: anObject [
	self visitEntry: anObject
]

{ #category : #'*pier-blog-model' }
PRVisitor >> visitEntry: anObject [
	self visitCase: anObject
]

{ #category : #'*pier-blog-model' }
PRVisitor >> visitPost: anObject [
	self visitEntry: anObject
]
