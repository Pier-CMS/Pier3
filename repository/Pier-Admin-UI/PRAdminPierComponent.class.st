"
Specialises ==PRPierFrame== to:
- hold the kernel which is passed to me by ==PRAdminLogin== when I am created.
- create a specialised context ==PRAdminContext== 
- provides an empty environment when rendering non-default views, where non-default views are defined by:

+value:source|class=PRAdminPierComponent |selector=isShowingPreview+
"
Class {
	#name : #PRAdminPierComponent,
	#superclass : #PRPierFrame,
	#instVars : [
		'kernel'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #'instance creation' }
PRAdminPierComponent class >> kernel: kernel [
	| pierComponent |
	pierComponent := self new
		kernel: kernel;
		yourself.
		
	pierComponent addContextFilter "need to manually add the context filter as #initialRequest: will not be called as we've only just created the component".
	
	^ pierComponent
]

{ #category : #accessing }
PRAdminPierComponent >> context [
	"Answer the admin context, ensuring creation of standard Seaside urls (not RESTful urls) within pier admin"
	^ context ifNil: [ context := PRAdminContext kernel: self kernel ]
]

{ #category : #accessing }
PRAdminPierComponent >> editingEnvironment [
	^ self context structure editingEnvironment

]

{ #category : #accessing }
PRAdminPierComponent >> environment [
	self isShowingPreview ifTrue: [ ^ super environment ].
	self isEditing ifTrue: [ ^ self editingEnvironment ].
	
	^ PRStructure emptyEnvironment

]

{ #category : #testing }
PRAdminPierComponent >> isEditing [
	^ self context command isKindOf: PREditCommand
]

{ #category : #testing }
PRAdminPierComponent >> isShowingPreview [
	^ self context command asComponent isKindOf: PRDefaultView
]

{ #category : #accessing }
PRAdminPierComponent >> kernel [
	^ kernel
]

{ #category : #accessing }
PRAdminPierComponent >> kernel: anObject [
	kernel := anObject.

]

{ #category : #'instance creation' }
PRAdminPierComponent >> setLoggedInUser: aUser [
	self context: (self context user: aUser)
]

{ #category : #updating }
PRAdminPierComponent >> updateRoot: anHtmlRoot [
	PRBlueprintLibrary default updateRoot: anHtmlRoot.
	PRJavaScriptSupport default updateRoot: anHtmlRoot. 
	
	super updateRoot: anHtmlRoot.

]
