Class {
	#name : #PRWysiwygEditorRenderer,
	#superclass : #PRViewRenderer,
	#instVars : [
		'wikiRenderer'
	],
	#category : #'Pier-Wysiwyg'
}

{ #category : #constants }
PRWysiwygEditorRenderer >> nonEditableCssClasses [
	^ 'yui-noedit pierNonEditable'
	

]

{ #category : #private }
PRWysiwygEditorRenderer >> renderInternalLink: aLink [
	| anchor  referenceRenderer |
	
	referenceRenderer := PRReferenceRenderer parent: self.
	referenceRenderer renderer: html.
	
	anchor := referenceRenderer anchorFor: aLink.
	anchor class: 'internal'; goto: (referenceRenderer contextForLink: aLink).
	aLink anchor isNil ifFalse: [ 
		anchor url fragment: (aLink anchor
			select: [ :each | each isAlphaNumeric ]) ].
	anchor 
		url: anchor url purgeSeasideFields;
		with: [ referenceRenderer visitLink: aLink ].

]

{ #category : #private }
PRWysiwygEditorRenderer >> renderNonEditableBrokenLink: aLink [
	html span
		class: 'broken';
		class: self nonEditableCssClasses;
			with: (PRPillarWriter write: aLink)

]

{ #category : #private }
PRWysiwygEditorRenderer >> renderNonEditableEmbeddedLink: aLink [
	html span
		class: 'pierEmbeddedLink';
		class: self nonEditableCssClasses;
			with: (PRPillarWriter write: aLink)

]

{ #category : #private }
PRWysiwygEditorRenderer >> renderUnknownInternalLinkType: aLink [ 
	html span
		class: 'pierUnknownInternalLinkType';
		class: self nonEditableCssClasses;
			with: [
				html text: (PRPillarWriter write: aLink) ]

]

{ #category : #'visiting-document' }
PRWysiwygEditorRenderer >> visitHeader: anObject [
	"override as in the editor we don't care about the named anchor"
	html heading level: anObject level; with: [
		self visitDocumentGroup: anObject ]
]

{ #category : #'visiting-document' }
PRWysiwygEditorRenderer >> visitIndexLink: aLink [ 
	html span
		class: 'pierIndexLink';
		class: self nonEditableCssClasses;
			with: [
				html text: (PRPillarWriter write: aLink) ]

]

{ #category : #'visiting-document' }
PRWysiwygEditorRenderer >> visitInternalLink: aLink [
	(aLink target notNil and: [ aLink target isFile ]) 
		ifTrue: [
			 ^ super visitInternalLink: aLink ].
		
	aLink isEmbedded
		ifTrue: [
			 ^ self renderNonEditableEmbeddedLink: aLink ].
		
	aLink target isNil 
		ifTrue: [
			^ self renderNonEditableBrokenLink: aLink ].
		
	(aLink class name = #PRInternalLink) not 
		ifTrue: [
			^ self renderUnknownInternalLinkType: aLink ].
	
	self renderInternalLink: aLink
	



]

{ #category : #'visiting-document' }
PRWysiwygEditorRenderer >> visitValueLink: aLink [ 
	html span
		class: 'pierValueLink';
		class: self nonEditableCssClasses;
			with: [
				html text: (PRPillarWriter write: aLink) ]

]

{ #category : #'visiting-document' }
PRWysiwygEditorRenderer >> visitVerbatim: aVerbatim [
	html span
		class: 'pierVerbatim';
		class: self nonEditableCssClasses;
			with: [
				html text: (PRPillarWriter write: aVerbatim) ] 
]
