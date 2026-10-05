Class {
	#name : 'PBRssEmbeddedRenderer',
	#superclass : 'PREmbeddedRenderer',
	#category : 'pier-blog-seaside',
	#package : 'pier-blog-seaside'
}

{ #category : 'visiting-structure' }
PBRssEmbeddedRenderer >> visitComponent: aStructure [
	"render links to components, rather than embedding them"
	html anchor
		goto: (self context structure: aStructure);
		with: aStructure title
]
