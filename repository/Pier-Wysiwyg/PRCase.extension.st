Extension { #name : #PRCase }

{ #category : #'*pier-wysiwyg' }
PRCase >> descriptionDocumentWysiwyg1: aDescription [
	<magritteDescription: #descriptionDocument>
	^ aDescription componentClass: PRWysiwygEditorComponent
]
