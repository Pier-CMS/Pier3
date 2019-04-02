"
Ensures that ==PRAdminHtmlRoot== is used during rendering.
"
Class {
	#name : #PRAdminRenderPhaseContinuation,
	#superclass : #WARenderPhaseContinuation,
	#category : #'Pier-Admin-UI'
}

{ #category : #private }
PRAdminRenderPhaseContinuation >> createHtmlRootWithContext: aRenderContext [
	^ PRAdminHtmlRoot context: aRenderContext
]
