"
Stores the head script and styles that are included during a page request in requestContext properties. This allows subsequent ajax updates to ensure that the same script isn't included multiple times. Only used on the initial full-page request.
"
Class {
	#name : #PRAdminHtmlDocumentStoredHeadElements,
	#superclass : #WAHtmlDocument,
	#category : #'Pier-Admin-UI'
}

{ #category : #actions }
PRAdminHtmlDocumentStoredHeadElements >> open: aRoot [
	"store the head script and styles that are included during a page request.
	Important so that subsequent ajax updates don't include the same script multiple times"
	
	"normally aRoot will be a PRAdminHtmlRoot however when a component contains
	an iFrame aRoot can be a WAHtmlRoot in which case we're outside the immediate
	scope of the admin wrapper and don't need to store the headScripts.
	
	Could have added #scripts & #styles on WAHtmlRoot and made them return 
	an empty collection but it seems less confusing to keep the logic within here"
	(aRoot class canUnderstand: #scripts) ifTrue: [
		self requestContext headScripts: aRoot scripts ].
	
	(aRoot class canUnderstand: #styles) ifTrue: [
		self requestContext headStyles: aRoot styles ].

	super open: aRoot.
]
