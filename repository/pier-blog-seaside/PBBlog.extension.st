Extension { #name : #PBBlog }

{ #category : #'*pier-blog-seaside' }
PBBlog >> isValidView: aComponentClass in: aContext [
	^ super viewComponentClass ~= aComponentClass
]

{ #category : #'*pier-blog-seaside' }
PBBlog >> viewComponentClass [
	^ PBBlogHtmlView
]
