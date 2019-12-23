Class {
	#name : #PRLinkRenderer,
	#superclass : #PRRenderer,
	#instVars : [
		'parent',
		'link'
	],
	#category : #'Pier-Seaside-Visitors'
}

{ #category : #'instance creation' }
PRLinkRenderer class >> parent: aVisitor [
	^ self new setParent: aVisitor
]

{ #category : #private }
PRLinkRenderer >> anchorFor: aLink [
	"Answer a default anchor for aLink."
	
	| anchor |
	anchor := html anchor.
	anchor attributes: (self attributesFor: aLink).
	anchor attributes at: 'title' ifAbsentPut: [ aLink title ].
	^ anchor
]

{ #category : #private }
PRLinkRenderer >> attributeNames [
	"Answer a list of valid HTML attributes that can be added to links and other elements."

	^ #('accesskey' 'align' 'alt' 'class' 'dir' 'disabled' 'height' 'id' 'lang' 'longdesc' 'style' 'tabindex' 'target' 'title' 'width')
]

{ #category : #private }
PRLinkRenderer >> attributesFor: aLink [
	"Answer a set of attributes from the link."

	| attributes |
	attributes := WAHtmlAttributes new.
	aLink parameters
		keysAndValuesDo: [ :k :v | 
			(self attributeNames includes: k)
				ifTrue: [ attributes at: k put: v ] ].
	^ attributes
]

{ #category : #initialization }
PRLinkRenderer >> setParent: aVisitor [
	parent := aVisitor
]

{ #category : #visiting }
PRLinkRenderer >> start: aLink [
	super start: (link := aLink)
]

{ #category : #'visiting-document' }
PRLinkRenderer >> visitExternalLink: aLink [
	(self anchorFor: aLink)
		url: aLink url;
		class: 'external';
		with: [ self visitLink: aLink ]
]

{ #category : #'visiting-document' }
PRLinkRenderer >> visitLink: aLink [
	"If present render the alias of the link with the default renderer, otherwise simply display the title."

	aLink hasAlias
		ifTrue: [ parent visitAll: aLink children ]
		ifFalse: [ html html: aLink title ]
]
