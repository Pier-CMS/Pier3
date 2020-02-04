Class {
	#name : #PRDocumentComponent,
	#superclass : #MATextAreaComponent,
	#category : #'Pier-Seaside-Magritte'
}

{ #category : #rendering }
PRDocumentComponent >> renderViewerOn: html [
	html rendererInstance visit: self value
]
