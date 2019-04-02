"
I provide a base for the admin ui components, allowing context sharing between components.
"
Class {
	#name : #PRAdminUIChild,
	#superclass : #PRAdminAnnouncingComponent,
	#instVars : [
		'contextGetCallback',
		'contextSetCallback'
	],
	#category : #'Pier-Admin-UI'
}

{ #category : #'instance creation' }
PRAdminUIChild class >> contextGetCallback: contextGetCallback contextSetCallback: contextSetCallback [
	^ self new
		contextGetCallback: contextGetCallback; 
		contextSetCallback: contextSetCallback;
		yourself
		
]

{ #category : #accessing }
PRAdminUIChild >> context [
	^ contextGetCallback value

]

{ #category : #accessing }
PRAdminUIChild >> context: anObject [
	contextSetCallback value: anObject

]

{ #category : #accessing }
PRAdminUIChild >> contextGetCallback: anObject [
	contextGetCallback := anObject
]

{ #category : #accessing }
PRAdminUIChild >> contextSetCallback: anObject [
	contextSetCallback := anObject
]
