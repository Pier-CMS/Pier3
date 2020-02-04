Class {
	#name : #PBRssEmbeddedRenderer,
	#superclass : #PREmbeddedRenderer,
	#category : #'Pier-Blog-Seaside'
}

{ #category : #'visiting-structure' }
PBRssEmbeddedRenderer >> visitComponent: aStructure [
	"render links to components, rather than embedding them"
	html anchor
		goto: (self context structure: aStructure);
		with: aStructure title
]
