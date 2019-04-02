Extension { #name : #PBPost }

{ #category : #'*pier-blog-seaside' }
PBPost >> isValidView: aComponentClass in: aContext [
	^ super viewComponentClass ~= aComponentClass
]

{ #category : #'*pier-blog-seaside' }
PBPost >> viewComponentClass [
	^ PBPostHtmlView
]
