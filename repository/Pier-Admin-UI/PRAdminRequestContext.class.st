"
Used during Ajax rendering cycles to set ==PRAdminHtmlDocumentSeparateBodyHeadElements== as the document type. ==PRAdminRequestContext== also provides access to the rendered document, allowing separate elements stored by ==PRAdminHtmlDocumentSeparateBodyHeadElements== to be extracted after rendering.
"
Class {
	#name : #PRAdminRequestContext,
	#superclass : #WARequestContext,
	#instVars : [
		'document'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #accessing }
PRAdminRequestContext >> document [
	^ document
]

{ #category : #'accessing-dynamic' }
PRAdminRequestContext >> newDocument [
	^ document := (PRAdminHtmlDocumentSeparateBodyHeadElements
		on: self response stream codec: self codec)
		scriptGenerator: (self handler configuration at: #scriptGeneratorClass) new;
		yourself
]
