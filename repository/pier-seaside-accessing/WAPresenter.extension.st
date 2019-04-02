Extension { #name : #WAPresenter }

{ #category : #'*pier-seaside-accessing' }
WAPresenter >> context [
	^ PRCurrentContext value
]

{ #category : #'*pier-seaside-accessing' }
WAPresenter >> context: aContext [
	PRCurrentContext value: aContext
]
