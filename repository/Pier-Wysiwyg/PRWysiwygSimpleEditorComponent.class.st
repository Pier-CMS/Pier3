Class {
	#name : #PRWysiwygSimpleEditorComponent,
	#superclass : #PRWysiwygEditorComponent,
	#category : #'Pier-Wysiwyg'
}

{ #category : #rendering }
PRWysiwygSimpleEditorComponent >> setEditorPermissions: anEditor [
	| editorConfiguration |
	editorConfiguration := anEditor configuration.
	editorConfiguration allowWikiTextEditing: false.
	editorConfiguration showSiteMapLinks: false.
]
