Class {
	#name : #BOLatexView,
	#superclass : #BOBookView,
	#category : #'Pier-Book-Latex'
}

{ #category : #accessing }
BOLatexView class >> label [
	^ 'Book LaTeX'
]

{ #category : #responding }
BOLatexView >> respondUsing: aResponse [
	super respondUsing: aResponse.
	aResponse
		contentType: 'text/latex';
		attachmentWithFileName: self book name , '.tex'.
	self writer write: self book to: aResponse stream
]
