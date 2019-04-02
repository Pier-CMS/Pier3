Extension { #name : #PRVisitor }

{ #category : #'*pier-book-model' }
PRVisitor >> visitBOFigure: anObject [
	self visitFile: anObject
]

{ #category : #'*pier-book-model' }
PRVisitor >> visitBook: aStructure [
	self visitPublication: aStructure
]

{ #category : #'*pier-book-model' }
PRVisitor >> visitIndexLink: aLink [
	self visitLink: aLink
]

{ #category : #'*pier-book-model' }
PRVisitor >> visitPortion: aStructure [
	self visitPublication: aStructure
]

{ #category : #'*pier-book-model' }
PRVisitor >> visitPublication: aStructure [
	self visitCase: aStructure
]

{ #category : #'*pier-book-model' }
PRVisitor >> visitReferenceLink: aLink [
	self visitInternalLink: aLink
]
