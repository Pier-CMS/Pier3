"
PRAdminHtmlRoot provides accessors for retrieving head script and styles generated during a render phase.
"
Class {
	#name : #PRAdminHtmlRoot,
	#superclass : #WAHtmlRoot,
	#category : #'Pier-Admin-UI'
}

{ #category : #acessing }
PRAdminHtmlRoot >> closingConditionalCommentClasses [
	^ #(WAClosingConditionalComment WAClosingRevealedConditionalComment)
]

{ #category : #acessing }
PRAdminHtmlRoot >> openingConditionalCommentClasses [
	^ #(WAOpeningConditionalComment WAOpeningRevealedConditionalComment)
]

{ #category : #helpers }
PRAdminHtmlRoot >> renderStyleFor: elements [
	| document |	
	document := WAHtmlDocument new.
		
	elements do: [ :each |
		each encodeOn: document ].
	
	^ document stream contents
]

{ #category : #acessing }
PRAdminHtmlRoot >> scripts [
	| headElementScripts |
	headElementScripts := (self headElements
		select: [ :each | (each class canUnderstand: #tag) and: [ each tag = 'script' ] ])
		collect: [ :each | each scriptContents ].
	^ headElementScripts , (scripts ifNil: [ #() ]) asArray
]

{ #category : #acessing }
PRAdminHtmlRoot >> styles [
	| styleElements groupedElements withinConditionalElement |
	styleElements := self headElements 
		select: [ :each | 
			(((each class canUnderstand: #typeOrNil) and: [ each typeOrNil = WAMimeType textCss ])
			or: [ self openingConditionalCommentClasses includes: each class name ])
			or: [ self closingConditionalCommentClasses includes: each class name ] ].
	
	"group conditional comments with styles so that we add the style within any conditional comments"
	groupedElements := 	OrderedCollection new.
	withinConditionalElement := false.
	styleElements do: [ :each |
		(self openingConditionalCommentClasses includes: each class name) 
			ifTrue: [
				withinConditionalElement := true.
				groupedElements add: (OrderedCollection with: each) ]
			ifFalse: [
				withinConditionalElement 
					ifTrue: [
						groupedElements last add: each ]
					ifFalse: [
						groupedElements add: (OrderedCollection with: each) ] ].
		(self closingConditionalCommentClasses includes: each class name) ifTrue: [
				withinConditionalElement := false ] ].

	^ (groupedElements collect: [ :each |
		self renderStyleFor: each ]), ((styles ifNil: [ #() ]) asArray)
]
