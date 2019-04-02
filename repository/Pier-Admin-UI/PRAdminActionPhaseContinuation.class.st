"
I specialise ==WAActionPhaseContinuation== to allow redirects to be configurable for GET and POST requests by adding the 'dontRedirect' request key. 
Used when rendering Ajax response to ensure the action continuation directly renders a response rather than a redirect.
"
Class {
	#name : #PRAdminActionPhaseContinuation,
	#superclass : #WAActionPhaseContinuation,
	#category : #'Pier-Admin-UI'
}

{ #category : #private }
PRAdminActionPhaseContinuation >> shouldRedirect [
	"in pier admin when we trigger a render request from an Ajax callback we want to render
	the result directly, rather than the rendering a redirect"
	 ^ (self request fields includesKey: 'dontRedirect') not
]
