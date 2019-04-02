Class {
	#name : #PRViewComponent,
	#superclass : #MAComponent,
	#instVars : [
		'context'
	],
	#category : #'Pier-Seaside-View'
}

{ #category : #testing }
PRViewComponent class >> isListed [
	^ true
]

{ #category : #testing }
PRViewComponent class >> isRestful [
	"Answer wether the component is fully restful."

	^ false
]

{ #category : #testing }
PRViewComponent class >> isValidIn: aContext [
	"Verify that a view as a meaning for the context aContext. Override this message, to add new tests, but do not forget to call this super implementation."

	^ self isAbstract not and: [ aContext structure isValidView: self in: aContext ]
]

{ #category : #accessing }
PRViewComponent class >> label [
	self subclassResponsibility
]

{ #category : #'instance creation' }
PRViewComponent class >> on: aContext [
	^ self new
		setContext: aContext;
		yourself
]

{ #category : #accessing }
PRViewComponent >> context [
	^ context
]

{ #category : #accessing }
PRViewComponent >> cssClass [
	"Answer a CSS class that should be used in the body-tag when this view is displayed."

	^ self class fullName asLowercase allButFirst: 2
]

{ #category : #private }
PRViewComponent >> find: aStructureClass [
	^ self context structure findAncestor: [ :each | each isKindOf: aStructureClass ]
]

{ #category : #responding }
PRViewComponent >> handle: aRequestContext [
	self isFullResponse ifFalse: [ self shouldNotImplement ].
	aRequestContext respond: [ :response | self respondUsing: response ]
]

{ #category : #testing }
PRViewComponent >> isFullResponse [
	"Returns true if the View generates a complete HTTP response."
	
	^ false
]

{ #category : #accessing }
PRViewComponent >> label [
	^ self class label
]

{ #category : #rendering }
PRViewComponent >> renderContentOn: html [
	html strong: self context
]

{ #category : #accessing }
PRViewComponent >> rendererInstance [
	^ PRViewRenderer new
]

{ #category : #responding }
PRViewComponent >> respondUsing: aResponse [
	"Allows views that return a full response to configure the Response."
]

{ #category : #accessing }
PRViewComponent >> robots [
	^ 'noindex,nofollow'
]

{ #category : #initialization }
PRViewComponent >> setContext: aContext [
	context := aContext
]

{ #category : #updating }
PRViewComponent >> updateRoot: aHtmlRoot [
	super updateRoot: aHtmlRoot.
	aHtmlRoot bodyAttributes addClass: self cssClass
]
