Class {
	#name : #PBRssRenderer,
	#superclass : #PRViewRenderer,
	#category : #'Pier-Blog-Seaside'
}

{ #category : #private }
PBRssRenderer >> linkRendererFor: aLink [
	"Answer an instance of the most appropriate renderer for this link. If the link is internal and embedded, avoid the embedding and simply create a reference."

	| class |
	class := aLink isBroken
		ifTrue: [ PRBrokenRenderer ]
		ifFalse: [
			(aLink isEmbedded not
				or: [ aLink isInternal
				and: [ aLink target hasDocument
				and: [ visited includes: aLink target ] ] ])
					ifTrue: [ PRReferenceRenderer ]
					ifFalse: [ PBRssEmbeddedRenderer ] ].

	^ class parent: self
]

{ #category : #'visiting-document' }
PBRssRenderer >> visitAnchor: anObject [
]

{ #category : #visiting }
PBRssRenderer >> visitLightBoxLink: aLink [

]

{ #category : #'visiting-document' }
PBRssRenderer >> visitParagraph: anObject [
	html paragraph: [ self visitAll: anObject children ]
]

{ #category : #'visiting-document' }
PBRssRenderer >> visitValueLink: anObject [
	"Ignore value links to avoid strange side-effects."
]
